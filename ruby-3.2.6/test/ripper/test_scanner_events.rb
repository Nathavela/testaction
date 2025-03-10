# frozen_string_literal: true
#
# test_scanner_events.rb
#
begin
  require 'ripper'
  require 'test/unit'
  ripper_test = true
  module TestRipper; end
rescue LoadError
end

class TestRipper::ScannerEvents < Test::Unit::TestCase

  def test_event_coverage
    dispatched = Ripper::SCANNER_EVENTS.map {|event,_| event }
    dispatched.each do |e|
      assert_respond_to(self, ["test_#{e}", true], "event not tested: #{e}")
    end
  end

  def scan(target, str, &error)
    sym = "on_#{target}".intern
    lexer = Ripper::Lexer.new(str)
    if error
      lexer.singleton_class.class_eval do
        define_method(:on_error) {|ev|
          yield __callee__, ev, token()
        }
        alias on_parse_error on_error
        alias compile_error on_error
      end
    end
    lexer.lex.select {|_,type,_| type == sym }.map {|_,_,tok| tok }
  end

  def test_tokenize
    assert_equal [],
                 Ripper.tokenize('')
    assert_equal ['a'],
                 Ripper.tokenize('a')
    assert_equal ['1'],
                 Ripper.tokenize('1')
    assert_equal ['1', ';', 'def', ' ', 'm', '(', 'arg', ')', 'end'],
                 Ripper.tokenize("1;def m(arg)end")
    assert_equal ['print', '(', '<<''EOS', ')', "\n", "heredoc\n", "EOS\n"],
                 Ripper.tokenize("print(<<""EOS)\nheredoc\nEOS\n")
    assert_equal ['print', '(', ' ', '<<''EOS', ')', "\n", "heredoc\n", "EOS\n"],
                 Ripper.tokenize("print( <<""EOS)\nheredoc\nEOS\n")
    assert_equal ["\#\n", "\n", "\#\n", "\n", "nil", "\n"],
                 Ripper.tokenize("\#\n\n\#\n\nnil\n")
    assert_equal ["1", "  ", ".", "foo", "\n"],
                 Ripper.tokenize("1  .foo\n")
    assert_equal ["1", "\n", "  ", ".", "foo", "\n"],
                 Ripper.tokenize("1\n  .foo\n")
    assert_equal ["def", " ", "f", ";", " ", "(", "x", ")", "::", "A", " ", "="],
                 Ripper.tokenize("def f; (x)::A =")
  end

  def test_lex
    assert_lex   [],
                 Ripper.lex('')
    assert_lex   [[[1,0], :on_ident, "a", Ripper::EXPR_CMDARG]],
                 Ripper.lex('a')
    assert_lex   [[[1, 0], :on_kw, "nil", Ripper::EXPR_END]],
                 Ripper.lex("nil")
    assert_lex   [[[1, 0], :on_kw, "def", Ripper::EXPR_FNAME],
                  [[1, 3], :on_sp, " ", Ripper::EXPR_FNAME],
                  [[1, 4], :on_ident, "m", Ripper::EXPR_ENDFN],
                  [[1, 5], :on_lparen, "(", Ripper::EXPR_BEG | Ripper::EXPR_LABEL],
                  [[1, 6], :on_ident, "a", Ripper::EXPR_ARG],
                  [[1, 7], :on_rparen, ")", Ripper::EXPR_ENDFN],
                  [[1, 8], :on_kw, "end", Ripper::EXPR_END]],
                 Ripper.lex("def m(a)end")
    assert_lex   [[[1, 0], :on_int, "1", Ripper::EXPR_END],
                  [[1, 1], :on_nl, "\n", Ripper::EXPR_BEG],
                  [[2, 0], :on_int, "2", Ripper::EXPR_END],
                  [[2, 1], :on_nl, "\n", Ripper::EXPR_BEG],
                  [[3, 0], :on_int, "3", Ripper::EXPR_END]],
                 Ripper.lex("1\n2\n3")
    assert_lex   [[[1, 0], :on_heredoc_beg, "<<""EOS", Ripper::EXPR_BEG],
                  [[1, 5], :on_nl, "\n", Ripper::EXPR_BEG],
                  [[2, 0], :on_tstring_content, "heredoc\n", Ripper::EXPR_BEG],
                  [[3, 0], :on_heredoc_end, "EOS", Ripper::EXPR_BEG]],
                 Ripper.lex("<<""EOS\nheredoc\nEOS")
    assert_lex   [[[1, 0], :on_heredoc_beg, "<<""EOS", Ripper::EXPR_BEG],
                  [[1, 5], :on_nl, "\n", Ripper::EXPR_BEG],
                  [[2, 0], :on_heredoc_end, "EOS", Ripper::EXPR_BEG]],
                 Ripper.lex("<<""EOS\nEOS"),
                 "bug#4543"
    assert_lex   [[[1, 0], :on_regexp_beg, "/", Ripper::EXPR_BEG],
                  [[1, 1], :on_tstring_content, "foo\nbar", Ripper::EXPR_BEG],
                  [[2, 3], :on_regexp_end, "/", Ripper::EXPR_BEG]],
                 Ripper.lex("/foo\nbar/")
    assert_lex   [[[1, 0], :on_regexp_beg, "/", Ripper::EXPR_BEG],
                  [[1, 1], :on_tstring_content, "foo\n\u3020", Ripper::EXPR_BEG],
                  [[2, 3], :on_regexp_end, "/", Ripper::EXPR_BEG]],
                 Ripper.lex("/foo\n\u3020/")
    assert_lex   [[[1, 0], :on_tstring_beg, "'", Ripper::EXPR_BEG],
                  [[1, 1], :on_tstring_content, "foo\n\xe3\x80\xa0", Ripper::EXPR_BEG],
                  [[2, 3], :on_tstring_end, "'", Ripper::EXPR_END]],
                 Ripper.lex("'foo\n\xe3\x80\xa0'")
    assert_lex   [[[1, 0], :on_tstring_beg, "'", Ripper::EXPR_BEG],
                  [[1, 1], :on_tstring_content, "\u3042\n\u3044", Ripper::EXPR_BEG],
                  [[2, 3], :on_tstring_end, "'", Ripper::EXPR_END]],
                 Ripper.lex("'\u3042\n\u3044'")
    assert_lex   [[[1, 0], :on_rational, "1r", Ripper::EXPR_END],
                  [[1, 2], :on_nl, "\n", Ripper::EXPR_BEG],
                  [[2, 0], :on_imaginary, "2i", Ripper::EXPR_END],
                  [[2, 2], :on_nl, "\n", Ripper::EXPR_BEG],
                  [[3, 0], :on_imaginary, "3ri", Ripper::EXPR_END],
                  [[3, 3], :on_nl, "\n", Ripper::EXPR_BEG],
                  [[4, 0], :on_rational, "4.2r", Ripper::EXPR_END],
                  [[4, 4], :on_nl, "\n", Ripper::EXPR_BEG],
                  [[5, 0], :on_imaginary, "5.6ri", Ripper::EXPR_END],
                 ],
                 Ripper.lex("1r\n2i\n3ri\n4.2r\n5.6ri")
     assert_lex   [[[1, 0], :on_heredoc_beg, "<<~EOS", Ripper::EXPR_BEG],
                   [[1, 6], :on_nl, "\n", Ripper::EXPR_BEG],
                   [[2, 0], :on_ignored_sp, "  ", Ripper::EXPR_BEG],
                   [[2, 2], :on_tstring_content, "heredoc\n", Ripper::EXPR_BEG],
                   [[3, 0], :on_heredoc_end, "EOS", Ripper::EXPR_BEG]
                 ],
                 Ripper.lex("<<~EOS\n  heredoc\nEOS")
    assert_lex   [[[1, 0], :on_tstring_beg, "'", Ripper::EXPR_BEG],
                  [[1, 1], :on_tstring_content, "foo", Ripper::EXPR_BEG]],
                 Ripper.lex("'foo")
  end

  def assert_lex(expected, *rest)
    expected = expected.map do |pos, type, tok, state, *rest|
      [pos, type, tok, Ripper::Lexer::State.new(state), *rest]
    end
    assert_equal(expected, *rest)
  end

  def test_location
    assert_location ""
    assert_location " "
    assert_location ":"
    assert_location "\n"
    assert_location "\r\n"
    assert_location "\n\n\n\n\n\r\n\n\n"
    assert_location "\n;\n;\n;\n;\n"
    assert_location "nil"
    assert_location "@ivar"
    assert_location "1;2;3"
    assert_location "1\n2\n3"
    assert_location "1\n2\n3\n"
    assert_location "def m(a) nil end"
    assert_location "if true then false else nil end"
    assert_location "BEGIN{print nil}"
    assert_location "%w(a b\nc\r\nd \ne )"
    assert_location %Q["a\nb\r\nc"]
    assert_location "print(<<""EOS)\nheredoc\nEOS\n"
    assert_location "print(<<-\"EOS\")\nheredoc\n     EOS\n"
    assert_location "'foo'"
    assert_location "'foo"
  end

  def assert_location(src)
    buf = ''.dup
    Ripper.lex(src).each do |pos, type, tok|
      line, col = *pos
      assert_equal buf.count("\n") + 1, line,
          "wrong lineno: #{tok.inspect} (#{type}) [#{line}:#{col}]"
      assert_equal buf.sub(/\A.*\n/m, '').size, col,
          "wrong column: #{tok.inspect} (#{type}) [#{line}:#{col}]"
      buf << tok
    end
    assert_equal src, buf
  end

  def test_backref
    assert_equal ["$`", "$&", "$'", '$1', '$2', '$3'],
                 scan('backref', %q[m($~, $`, $&, $', $1, $2, $3)])
  end

  def test_backtick
    assert_equal ["`"],
                 scan('backtick', %q[p `make all`])
  end

  def test_colon2_call
    assert_equal ["::"],
                 scan('op', %q[ a::b ])
  end

  def test_comma
    assert_equal [','] * 6,
                 scan('comma', %q[ m(0,1,2,3,4,5,6) ])
    assert_equal [],
                 scan('comma', %q[".,.,.,.,.,.,.."])
    assert_equal [],
                 scan('comma', "<<""EOS\n,,,,,,,,,,\nEOS")
  end

  def test_period
    assert_equal [],
                 scan('period', '')
    assert_equal ['.'],
                 scan('period', 'a.b')
    assert_equal ['.'],
                 scan('period', 'Object.new')
    assert_equal [],
                 scan('period', '"."')
    assert_equal [],
                 scan('period', '1..2')
    assert_equal [],
                 scan('period', '1...3')
  end

  def test_const
    assert_equal ['CONST'],
                 scan('const', 'CONST')
    assert_equal ['C'],
                 scan('const', 'C')
    assert_equal ['CONST_A'],
                 scan('const', 'CONST_A')
    assert_equal ['Const', 'Const2', 'Const3'],
                 scan('const', 'Const; Const2; Const3')
    assert_equal ['Const'],
                 scan('const', 'Const(a)')
    assert_equal ['M', 'A', 'A2'],
                 scan('const', 'M(A,A2)')
    assert_equal [],
                 scan('const', '')
    assert_equal [],
                 scan('const', 'm(lvar, @ivar, @@cvar, $gvar)')
  end

  def test_cvar
    assert_equal [],
                 scan('cvar', '')
    assert_equal ['@@cvar'],
                 scan('cvar', '@@cvar')
    assert_equal ['@@__cvar__'],
                 scan('cvar', '@@__cvar__')
    assert_equal ['@@CVAR'],
                 scan('cvar', '@@CVAR')
    assert_equal ['@@cvar'],
                 scan('cvar', '   @@cvar#comment')
    assert_equal ['@@cvar'],
                 scan('cvar', ':@@cvar')
    assert_equal ['@@cvar'],
                 scan('cvar', 'm(lvar, @ivar, @@cvar, $gvar)')
    assert_equal [],
                 scan('cvar', '"@@cvar"')
  end

  def test_embexpr_beg
    assert_equal [],
                 scan('embexpr_beg', '')
    assert_equal ['#{'],
                 scan('embexpr_beg', '"#{expr}"')
    assert_equal [],
                 scan('embexpr_beg', '%q[#{expr}]')
    assert_equal ['#{'],
                 scan('embexpr_beg', '%Q[#{expr}]')
    assert_equal ['#{'],
                 scan('embexpr_beg', "m(<<""EOS)\n\#{expr}\nEOS")
  end

  def test_embexpr_end
    assert_equal [],
                 scan('embexpr_end', '')
    assert_equal ['}'],
                 scan('embexpr_end', '"#{expr}"')
    assert_equal [],
                 scan('embexpr_end', '%q[#{expr}]')
    assert_equal ['}'],
                 scan('embexpr_end', '%Q[#{expr}]')
    assert_equal ['}'],
                 scan('embexpr_end', "m(<<""EOS)\n\#{expr}\nEOS")
  end

  def test_embvar
    assert_equal [],
                 scan('embvar', '')
    assert_equal ['#'],
                 scan('embvar', '"#$gvar"')
    assert_equal ['#'],
                 scan('embvar', '"#@ivar"')
    assert_equal ['#'],
                 scan('embvar', '"#@@cvar"')
    assert_equal [],
                 scan('embvar', '"#@1"')
    assert_equal [],
                 scan('embvar', '"#lvar"')
    assert_equal [],
                 scan('embvar', '"#"')
    assert_equal [],
                 scan('embvar', '"\#$gvar"')
    assert_equal [],
                 scan('embvar', '"\#@ivar"')
    assert_equal [],
                 scan('embvar', '%q[#@ivar]')
    assert_equal ['#'],
                 scan('embvar', '%Q[#@ivar]')
  end

  def test_float
    assert_equal [],
                 scan('float', '')
    assert_equal ['1.000'],
                 scan('float', '1.000')
    assert_equal ['123.456'],
                 scan('float', '123.456')
    assert_equal ['1.2345678901234567890123456789'],
                 scan('float', '1.2345678901234567890123456789')
    assert_equal ['1.000'],
                 scan('float', '   1.000# comment')
    assert_equal ['1.234e5'],
                 scan('float', '1.234e5')
    assert_equal ['1.234e1234567890'],
                 scan('float', '1.234e1234567890')
    assert_equal ['1.0'],
                 scan('float', 'm(a,b,1.0,c,d)')
  end

  def test_rational
    assert_equal [],
                 scan('rational', '')
    assert_equal ['1r', '10r', '10.1r'],
                 scan('rational', 'm(1r,10r,10.1r)')
  end

  def test_gvar
    assert_equal [],
                 scan('gvar', '')
    assert_equal ['$a'],
                 scan('gvar', '$a')
    assert_equal ['$A'],
                 scan('gvar', '$A')
    assert_equal ['$gvar'],
                 scan('gvar', 'm(lvar, @ivar, @@cvar, $gvar)')
    assert_equal %w($_ $~ $* $$ $? $! $@ $/ $\\ $; $, $. $= $: $< $> $"),
                 scan('gvar', 'm($_, $~, $*, $$, $?, $!, $@, $/, $\\, $;, $,, $., $=, $:, $<, $>, $")')
  end

  def test_ident
    assert_equal [],
                 scan('ident', '')
    assert_equal ['lvar'],
                 scan('ident', 'lvar')
    assert_equal ['m', 'lvar'],
                 scan('ident', 'm(lvar, @ivar, @@cvar, $gvar)')
  end

  def test_imaginary
    assert_equal [],
                 scan('imaginary', '')
    assert_equal ['1i', '10ri', '10.0i', '10.1ri'],
                 scan('imaginary', 'm(1i,10ri,10.0i,10.1ri)')
  end

  def test_int
    assert_equal [],
                 scan('int', '')
    assert_equal ['1', '10', '100000000000000'],
                 scan('int', 'm(1,10,100000000000000)')
  end

  def test_ivar
    assert_equal [],
                 scan('ivar', '')
    assert_equal ['@ivar'],
                 scan('ivar', '@ivar')
    assert_equal ['@__ivar__'],
                 scan('ivar', '@__ivar__')
    assert_equal ['@IVAR'],
                 scan('ivar', '@IVAR')
    assert_equal ['@ivar'],
                 scan('ivar', 'm(lvar, @ivar, @@cvar, $gvar)')
  end

  def test_kw
    assert_equal [],
                 scan('kw', '')
    assert_equal %w(not),
                 scan('kw', 'not 1')
    assert_equal %w(and),
                 scan('kw', '1 and 2')
    assert_equal %w(or),
                 scan('kw', '1 or 2')
    assert_equal %w(if then else end),
                 scan('kw', 'if 1 then 2 else 3 end')
    assert_equal %w(if then elsif else end),
                 scan('kw', 'if 1 then 2 elsif 3 else 4 end')
    assert_equal %w(unless then end),
                 scan('kw', 'unless 1 then end')
    assert_equal %w(if true),
                 scan('kw', '1 if true')
    assert_equal %w(unless false),
                 scan('kw', '2 unless false')
    assert_equal %w(case when when else end),
                 scan('kw', 'case n; when 1; when 2; else 3 end')
    assert_equal %w(while do nil end),
                 scan('kw', 'while 1 do nil end')
    assert_equal %w(until do nil end),
                 scan('kw', 'until 1 do nil end')
    assert_equal %w(while),
                 scan('kw', '1 while 2')
    assert_equal %w(until),
                 scan('kw', '1 until 2')
    assert_equal %w(while break next retry end),
                 scan('kw', 'while 1; break; next; retry end')
    assert_equal %w(for in next break end),
                 scan('kw', 'for x in obj; next 1; break 2 end')
    assert_equal %w(begin rescue retry end),
                 scan('kw', 'begin 1; rescue; retry; end')
    assert_equal %w(rescue),
                 scan('kw', '1 rescue 2')
    assert_equal %w(def redo return end),
                 scan('kw', 'def m() redo; return end')
    assert_equal %w(def yield yield end),
                 scan('kw', 'def m() yield; yield 1 end')
    assert_equal %w(def super super super end),
                 scan('kw', 'def m() super; super(); super(1) end')
    assert_equal %w(alias),
                 scan('kw', 'alias a b')
    assert_equal %w(undef),
                 scan('kw', 'undef public')
    assert_equal %w(class end),
                 scan('kw', 'class A < Object; end')
    assert_equal %w(module end),
                 scan('kw', 'module M; end')
    assert_equal %w(class end),
                 scan('kw', 'class << obj; end')
    assert_equal %w(BEGIN),
                 scan('kw', 'BEGIN { }')
    assert_equal %w(END),
                 scan('kw', 'END { }')
    assert_equal %w(self),
                 scan('kw', 'self.class')
    assert_equal %w(nil true false),
                 scan('kw', 'p(nil, true, false)')
    assert_equal %w(__FILE__ __LINE__),
                 scan('kw', 'p __FILE__, __LINE__')
    assert_equal %w(defined?),
                 scan('kw', 'defined?(Object)')
  end

  def test_lbrace
    assert_equal [],
                 scan('lbrace', '')
    assert_equal ['{'],
                 scan('lbrace', '3.times{ }')
    assert_equal ['{'],
                 scan('lbrace', '3.times  { }')
    assert_equal ['{'],
                 scan('lbrace', '3.times{}')
    assert_equal [],
                 scan('lbrace', '"{}"')
    assert_equal ['{'],
                 scan('lbrace', '{1=>2}')
  end

  def test_rbrace
    assert_equal [],
                 scan('rbrace', '')
    assert_equal ['}'],
                 scan('rbrace', '3.times{ }')
    assert_equal ['}'],
                 scan('rbrace', '3.times  { }')
    assert_equal ['}'],
                 scan('rbrace', '3.times{}')
    assert_equal [],
                 scan('rbrace', '"{}"')
    assert_equal ['}'],
                 scan('rbrace', '{1=>2}')
  end

  def test_lbracket
    assert_equal [],
                 scan('lbracket', '')
    assert_equal ['['],
                 scan('lbracket', '[]')
    assert_equal ['['],
                 scan('lbracket', 'a[1]')
    assert_equal [],
                 scan('lbracket', 'm(%q[])')
  end

  def test_rbracket
    assert_equal [],
                 scan('rbracket', '')
    assert_equal [']'],
                 scan('rbracket', '[]')
    assert_equal [']'],
                 scan('rbracket', 'a[1]')
    assert_equal [],
                 scan('rbracket', 'm(%q[])')
  end

  def test_lparen
    assert_equal [],
                 scan('lparen', '')
    assert_equal ['('],
                 scan('lparen', '()')
    assert_equal ['('],
                 scan('lparen', 'm()')
    assert_equal ['('],
                 scan('lparen', 'm (a)')
    assert_equal [],
                 scan('lparen', '"()"')
    assert_equal [],
                 scan('lparen', '"%w()"')
  end

  def test_rparen
    assert_equal [],
                 scan('rparen', '')
    assert_equal [')'],
                 scan('rparen', '()')
    assert_equal [')'],
                 scan('rparen', 'm()')
    assert_equal [')'],
                 scan('rparen', 'm (a)')
    assert_equal [],
                 scan('rparen', '"()"')
    assert_equal [],
                 scan('rparen', '"%w()"')
  end

  def test_op
    assert_equal [],
                 scan('op', '')
    assert_equal ['|'],
                 scan('op', '1 | 1')
    assert_equal ['^'],
                 scan('op', '1 ^ 1')
    assert_equal ['&'],
                 scan('op', '1 & 1')
    assert_equal ['<=>'],
                 scan('op', '1 <=> 1')
    assert_equal ['=='],
                 scan('op', '1 == 1')
    assert_equal ['==='],
                 scan('op', '1 === 1')
    assert_equal ['=~'],
                 scan('op', '1 =~ 1')
    assert_equal ['>'],
                 scan('op', '1 > 1')
    assert_equal ['>='],
                 scan('op', '1 >= 1')
    assert_equal ['<'],
                 scan('op', '1 < 1')
    assert_equal ['<='],
                 scan('op', '1 <= 1')
    assert_equal ['<''<'],
                 scan('op', '1 <''< 1')
    assert_equal ['>>'],
                 scan('op', '1 >> 1')
    assert_equal ['+'],
                 scan('op', '1 + 1')
    assert_equal ['-'],
                 scan('op', '1 - 1')
    assert_equal ['*'],
                 scan('op', '1 * 1')
    assert_equal ['/'],
                 scan('op', '1 / 1')
    assert_equal ['%'],
                 scan('op', '1 % 1')
    assert_equal ['**'],
                 scan('op', '1 ** 1')
    assert_equal ['~'],
                 scan('op', '~1')
    assert_equal ['-'],
                 scan('op', '-a')
    assert_equal ['+'],
                 scan('op', '+a')
    assert_equal ['[]'],
                 scan('op', ':[]')
    assert_equal ['[]='],
                 scan('op', ':[]=')
    assert_equal ['&.'],
                 scan('op', 'a&.f')
    assert_equal [],
                 scan('op', %q[`make all`])
  end

  def test_symbeg
    assert_equal [],
                 scan('symbeg', '')
    assert_equal [':'],
                 scan('symbeg', ':sym')
    assert_equal [':'],
                 scan('symbeg', '[1,2,3,:sym]')
    assert_equal [],
                 scan('symbeg', '":sym"')
    assert_equal [],
                 scan('symbeg', 'a ? b : c')
  end

  def test_tstring_beg
    assert_equal [],
                 scan('tstring_beg', '')
    assert_equal ['"'],
                 scan('tstring_beg', '"abcdef"')
    assert_equal ['%q['],
                 scan('tstring_beg', '%q[abcdef]')
    assert_equal ['%Q['],
                 scan('tstring_beg', '%Q[abcdef]')
  end

  def test_tstring_content
    assert_equal [],
                 scan('tstring_content', '')
    assert_equal ['abcdef'],
                 scan('tstring_content', '"abcdef"')
    assert_equal ['abcdef'],
                 scan('tstring_content', '%q[abcdef]')
    assert_equal ['abcdef'],
                 scan('tstring_content', '%Q[abcdef]')
    assert_equal ['abc', 'def'],
                 scan('tstring_content', '"abc#{1}def"')
    assert_equal ['sym'],
                 scan('tstring_content', ':"sym"')
    assert_equal ['a b c'],
                 scan('tstring_content', ':"a b c"'),
                 "bug#4544"
    assert_equal ["a\nb\nc"],
                 scan('tstring_content', ":'a\nb\nc'"),
                 "bug#4544"
  end

  def test_tstring_end
    assert_equal [],
                 scan('tstring_end', '')
    assert_equal ['"'],
                 scan('tstring_end', '"abcdef"')
    assert_equal [']'],
                 scan('tstring_end', '%q[abcdef]')
    assert_equal [']'],
                 scan('tstring_end', '%Q[abcdef]')
  end

  def test_regexp_beg
    assert_equal [],
                 scan('regexp_beg', '')
    assert_equal ['/'],
                 scan('regexp_beg', '/re/')
    assert_equal ['%r<'],
                 scan('regexp_beg', '%r<re>')
    assert_equal [],
                 scan('regexp_beg', '5 / 5')
  end

  def test_regexp_end
    assert_equal [],
                 scan('regexp_end', '')
    assert_equal ['/'],
                 scan('regexp_end', '/re/')
    assert_equal ['>'],
                 scan('regexp_end', '%r<re>')
  end

  def test_words_beg
    assert_equal [],
                 scan('words_beg', '')
    assert_equal ['%W('],
                 scan('words_beg', '%W()')
    assert_equal ['%W('],
                 scan('words_beg', '%W(w w w)')
    assert_equal ['%W('],
                 scan('words_beg', '%W( w w w )')
    assert_equal ['%W('],
                 scan('words_beg', "%W(\nw)")
  end

  def test_qwords_beg
    assert_equal [],
                 scan('qwords_beg', '')
    assert_equal ['%w('],
                 scan('qwords_beg', '%w()')
    assert_equal ['%w('],
                 scan('qwords_beg', '%w(w w w)')
    assert_equal ['%w('],
                 scan('qwords_beg', '%w( w w w )')
    assert_equal ['%w('],
                 scan('qwords_beg', "%w(\nw)")
  end

  def test_qsymbols_beg
    assert_equal [],
                 scan('qsymbols_beg', '')
    assert_equal ['%i('],
                 scan('qsymbols_beg', '%i()')
    assert_equal ['%i('],
                 scan('qsymbols_beg', '%i(w w w)')
    assert_equal ['%i('],
                 scan('qsymbols_beg', '%i( w w w )')
    assert_equal ['%i('],
                 scan('qsymbols_beg', "%i(\nw)")
  end

  def test_symbols_beg
    assert_equal [],
                 scan('symbols_beg', '')
    assert_equal ['%I('],
                 scan('symbols_beg', '%I()')
    assert_equal ['%I('],
                 scan('symbols_beg', '%I(w w w)')
    assert_equal ['%I('],
                 scan('symbols_beg', '%I( w w w )')
    assert_equal ['%I('],
                 scan('symbols_beg', "%I(\nw)")
  end

  def test_words_sep
    assert_equal [],
                 scan('words_sep', '')
    assert_equal [],
                 scan('words_sep', '%w()')
    assert_equal [' ', ' '],
                 scan('words_sep', '%w(w w w)')
    assert_equal [' ', ' ', ' ', ' '],
                 scan('words_sep', '%w( w w w )')
    assert_equal [' ', "\n", ' ', ' '],
                 scan('words_sep', "%w( w\nw w )")
    assert_equal ["\n\n", "\n ", ' ', ' '],
                 scan('words_sep', "%w(\n\nw\n w w )")
  end

  def test_heredoc_beg
    assert_equal [],
                 scan('heredoc_beg', '')
    assert_equal ['<<''EOS'],
                 scan('heredoc_beg', "<<""EOS\nheredoc\nEOS")
    assert_equal ['<<''EOS'],
                 scan('heredoc_beg', "<<""EOS\nheredoc\nEOS\n")
    assert_equal ['<<''EOS'],
                 scan('heredoc_beg', "<<""EOS\nheredoc\nEOS \n")
    assert_equal ['<<''-EOS'],
                 scan('heredoc_beg', "<<""-EOS\nheredoc\n\tEOS \n")
    assert_equal ['<<''"EOS"'],
                 scan('heredoc_beg', '<<''"EOS"'"\nheredoc\nEOS")
    assert_equal ["<<""'EOS'"],
                 scan('heredoc_beg', "<<""'EOS'\nheredoc\nEOS")
    assert_equal ['<<''`EOS`'],
                 scan('heredoc_beg', "<<""`EOS`\nheredoc\nEOS")
    assert_equal ['<<''" "'],
                 scan('heredoc_beg', '<<''" "'"\nheredoc\nEOS")
  end

  def test_tstring_content_HEREDOC
    assert_equal [],
                 scan('tstring_content', '')
    assert_equal ["heredoc\n"],
                 scan('tstring_content', "<<""EOS\nheredoc\nEOS")
    assert_equal ["heredoc\n"],
                 scan('tstring_content', "<<""EOS\nheredoc\nEOS\n")
    assert_equal ["here\ndoc \nEOS \n"],
                 scan('tstring_content', "<<""EOS\nhere\ndoc \nEOS \n")
    assert_equal ["heredoc\n\tEOS \n"],
                 scan('tstring_content', "<<""-EOS\nheredoc\n\tEOS \n")
    bug7255 = '[ruby-core:48703]'
    assert_equal ["there\n""heredoc", "\n"],
                 scan('tstring_content', "<<""EOS\n""there\n""heredoc\#{foo}\nEOS"),
                 bug7255
    assert_equal ["there\n""heredoc", "\n"],
                 scan('tstring_content', "<<""EOS\n""there\n""heredoc\#@foo\nEOS"),
                 bug7255
    bug10392 = '[ruby-dev:48647] [Bug #10392]'
    assert_equal [" E\n\n"],
                 scan('tstring_content', "<<""'E'\n E\n\n"),
                 bug10392
                 scan('tstring_content', "tap{<<""EOS}\n""there\n""heredoc\#@1xxx\nEOS")
  end

  def test_heredoc_end
    assert_equal [],
                 scan('heredoc_end', '')
    assert_equal ["EOS"],
                 scan('heredoc_end', "<<""EOS\nEOS"),
                 "bug#4543"
    assert_equal ["EOS"],
                 scan('heredoc_end', "<<""EOS\nheredoc\nEOS")
    assert_equal ["EOS\n"],
                 scan('heredoc_end', "<<""EOS\nheredoc\nEOS\n")
    assert_equal [],
                 scan('heredoc_end', "<<""EOS\nheredoc\nEOS \n")
    assert_equal [],
                 scan('heredoc_end', "<<""-EOS\nheredoc\n\tEOS \n")
  end

  def test_semicolon
    assert_equal [],
                 scan('semicolon', '')
    assert_equal %w(;),
                 scan('semicolon', ';')
    assert_equal %w(; ;),
                 scan('semicolon', '; ;')
    assert_equal %w(; ; ;),
                 scan('semicolon', 'nil;nil;nil;')
    assert_equal %w(; ; ;),
                 scan('semicolon', 'nil;nil;nil;nil')
    assert_equal [],
                 scan('semicolon', '";"')
    assert_equal [],
                 scan('semicolon', '%w(;)')
    assert_equal [],
                 scan('semicolon', '/;/')
  end

  def test_comment
    assert_equal [],
                 scan('comment', '')
    assert_equal ['# comment'],
                 scan('comment', '# comment')
    assert_equal ["# comment\n"],
                 scan('comment', "# comment\n")
    assert_equal ["# comment\n"],
                 scan('comment', "# comment\n1 + 1")
    assert_equal ["# comment\n"],
                 scan('comment', "1 + 1 + 1# comment\n1 + 1")
  end

  def test_embdoc_beg
    assert_equal [],
                 scan('embdoc_beg', '')
    assert_equal ["=begin\n"],
                 scan('embdoc_beg', "=begin\ndoc\n=end")
    assert_equal ["=begin \n"],
                 scan('embdoc_beg', "=begin \ndoc\n=end\n")
    assert_equal ["=begin comment\n"],
                 scan('embdoc_beg', "=begin comment\ndoc\n=end\n")
  end

  def test_embdoc
    assert_equal [],
                 scan('embdoc', '')
    assert_equal ["doc\n"],
                 scan('embdoc', "=begin\ndoc\n=end")
    assert_equal ["doc\n"],
                 scan('embdoc', "=begin\ndoc\n=end\n")
  end

  def test_embdoc_end
    assert_equal [],
                 scan('embdoc_end', '')
    assert_equal ["=end"],
                 scan('embdoc_end', "=begin\ndoc\n=end")
    assert_equal ["=end\n"],
                 scan('embdoc_end', "=begin\ndoc\n=end\n")
  end

  def test_sp
    assert_equal [],
                 scan('sp', '')
    assert_equal [' '],
                 scan('sp', ' ')
    assert_equal [' '],
                 scan('sp', ' 1')
    assert_equal [],
                 scan('sp', "\n")
    assert_equal [' '],
                 scan('sp', " \n")
    assert_equal [' ', ' '],
                 scan('sp', "1 + 1")
    assert_equal [],
                 scan('sp', "' '")
    assert_equal [],
                 scan('sp', "%w(  )")
    assert_equal [],
                 scan('sp', "%w(  w  )")
    assert_equal [],
                 scan('sp', "p(/ /)")

    assert_equal ["\\\n"],
                 scan('sp', "\\\n")
    assert_equal ['\ '],
                 scan('sp', '\ ')
  end

  # `nl' event always means End-Of-Statement.
  def test_nl
    assert_equal [],
                 scan('nl', '')
    assert_equal [],
                 scan('nl', "\n")
    assert_equal ["\n"],
                 scan('nl', "1 + 1\n")
    assert_equal ["\n", "\n"],
                 scan('nl', "1 + 1\n2 + 2\n")
    assert_equal [],
                 scan('nl', "1 +\n1")
    assert_equal [],
                 scan('nl', "1;\n")
    assert_equal ["\r\n"],
                 scan('nl', "1 + 1\r\n")
    assert_equal [],
                 scan('nl', "1;\r\n")
  end

  def test_ignored_nl
    assert_equal [],
                 scan('ignored_nl', '')
    assert_equal ["\n"],
                 scan('ignored_nl', "\n")
    assert_equal [],
                 scan('ignored_nl', "1 + 1\n")
    assert_equal [],
                 scan('ignored_nl', "1 + 1\n2 + 2\n")
    assert_equal ["\n"],
                 scan('ignored_nl', "1 +\n1")
    assert_equal ["\n"],
                 scan('ignored_nl', "1;\n")
    assert_equal [],
                 scan('ignored_nl', "1 + 1\r\n")
    assert_equal ["\r\n"],
                 scan('ignored_nl', "1;\r\n")
  end

  def test_ignored_sp
    assert_equal [],
                 scan('ignored_sp', "<<~EOS\nheredoc\nEOS")
    assert_equal ["  "],
                 scan('ignored_sp', "<<~EOS\n  heredoc\nEOS")
  end

  def test___end__
    assert_equal [],
                 scan('__end__', "")
    assert_equal ["__END__"],
                 scan('__end__', "__END__")
    assert_equal ["__END__\n"],
                 scan('__end__', "__END__\n")
    assert_equal ["__END__\n"],
                 Ripper.tokenize("__END__\njunk junk junk")
    assert_equal ["__END__"],
                 scan('__end__', "1\n__END__")
    assert_equal [],
                 scan('__end__', "print('__END__')")
  end

  def test_CHAR
    assert_equal [],
                 scan('CHAR', "")
    assert_equal ["?a"],
                 scan('CHAR', "?a")
    assert_equal [],
                 scan('CHAR', "@ivar")

    assert_equal ["?\\M-H"], scan('CHAR', '?\\M-H')

    assert_equal ["?\\u0041"],
                 scan('CHAR', "?\\u0041")

    assert_equal ["?\\u{41}"],
                 scan('CHAR', "?\\u{41}")

    err = nil
    assert_equal [], scan('CHAR', '?\\M ') {|*e| err = e}
    assert_equal([:on_parse_error, "Invalid escape character syntax", "?\\M "], err)

    err = nil
    scan('CHAR', '?\u{41 42}') {|*e| err = e}
    assert_equal [:on_parse_error, "Multiple codepoints at single character literal", "42"], err
  end

  def test_label
    assert_equal %w(foo:),
                 scan('label', '{foo: 1}')
  end

  def test_label_end
    assert_equal %w(":),
                 scan('label_end', '{"foo-bar": 1}')
  end

  def test_tlambda
    assert_equal %w(->),
                 scan('tlambda', '->{}')
  end

  def test_tlambeg
    assert_equal %w({),
                 scan('tlambeg', '-> {}')
  end

  def test_tlambda_arg
    assert_equal %w(),
                 scan('tlambda_arg', '-> {}')
  end

  def test_invalid_char
    err = nil
    assert_equal(['a'], scan('ident', "\ea") {|*e| err = e})
    assert_equal(:compile_error, err[0])
    assert_match(/Invalid char/, err[1])
    assert_equal("\e", err[2])
  end

  def test_invalid_escape
    err = nil
    assert_equal ["\\C-\u{3042}"], scan('tstring_content', %["\\C-\u{3042}"]) {|*e| err = e}
    assert_equal [:on_parse_error, "Invalid escape character syntax", "\\C-\u{3042}"], err
  end

  def test_invalid_hex_escape
    err = nil
    assert_equal ['U'], scan('tstring_content', '"\\xU"') {|*e| err = e}
    assert_equal [:on_parse_error, "invalid hex escape", "\\x"], err

    err = nil
    assert_equal ['U'], scan('tstring_content', '/\\xU/') {|*e| err = e}
    assert_equal [:on_parse_error, "invalid hex escape", "\\x"], err
  end
end if ripper_test
