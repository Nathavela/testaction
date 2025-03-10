/* -*-c-*- */
/*
 * included by eval.c
 */

#define write_warn(str, x) \
    (NIL_P(str) ? warn_print(x) : (void)rb_str_cat_cstr(str, x))
#define write_warn2(str, x, l) \
    (NIL_P(str) ? warn_print2(x, l) : (void)rb_str_cat(str, x, l))
#ifdef HAVE_BUILTIN___BUILTIN_CONSTANT_P
#define warn_print(x) RB_GNUC_EXTENSION_BLOCK(	\
    (__builtin_constant_p(x)) ? 		\
        rb_write_error2((x), (long)strlen(x)) : \
        rb_write_error(x)			\
)
#else
#define warn_print(x) rb_write_error(x)
#endif

#define warn_print2(x,l) rb_write_error2((x),(l))

#define write_warn_str(str,x) NIL_P(str) ? rb_write_error_str(x) : (void)rb_str_concat((str), (x))
#define warn_print_str(x) rb_write_error_str(x)

static VALUE error_pos_str(void);

static void
error_pos(const VALUE str)
{
    VALUE pos = error_pos_str();
    if (!NIL_P(pos)) {
        write_warn_str(str, pos);
    }
}

static VALUE
error_pos_str(void)
{
    int sourceline;
    VALUE sourcefile = rb_source_location(&sourceline);

    if (!NIL_P(sourcefile)) {
        ID caller_name;
        if (sourceline == 0) {
            return rb_sprintf("%"PRIsVALUE": ", sourcefile);
        }
        else if ((caller_name = rb_frame_callee()) != 0) {
            return rb_sprintf("%"PRIsVALUE":%d:in `%"PRIsVALUE"': ",
                              sourcefile, sourceline,
                              rb_id2str(caller_name));
        }
        else {
            return rb_sprintf("%"PRIsVALUE":%d: ", sourcefile, sourceline);
        }
    }
    return Qnil;
}

static void
set_backtrace(VALUE info, VALUE bt)
{
    ID set_backtrace = rb_intern("set_backtrace");

    if (rb_backtrace_p(bt)) {
        if (rb_method_basic_definition_p(CLASS_OF(info), set_backtrace)) {
            rb_exc_set_backtrace(info, bt);
            return;
        }
        else {
            bt = rb_backtrace_to_str_ary(bt);
        }
    }
    rb_check_funcall(info, set_backtrace, 1, &bt);
}

#define CSI_BEGIN "\033["
#define CSI_SGR "m"

static const char underline[] = CSI_BEGIN"1;4"CSI_SGR;
static const char bold[] = CSI_BEGIN"1"CSI_SGR;
static const char reset[] = CSI_BEGIN""CSI_SGR;

static void
print_errinfo(const VALUE eclass, const VALUE errat, const VALUE emesg, const VALUE str, int highlight)
{
    long elen = 0;
    VALUE mesg;

    if (NIL_P(errat) || RARRAY_LEN(errat) == 0 ||
        NIL_P(mesg = RARRAY_AREF(errat, 0))) {
        error_pos(str);
    }
    else {
        write_warn_str(str, mesg);
        write_warn(str, ": ");
    }

    if (!NIL_P(emesg)) {
        elen = RSTRING_LEN(emesg);
    }

    if (eclass == rb_eRuntimeError && elen == 0) {
        if (highlight) write_warn(str, underline);
        write_warn(str, "unhandled exception");
        if (highlight) write_warn(str, reset);
        write_warn2(str, "\n", 1);
    }
    else {
        VALUE epath;

        epath = rb_class_name(eclass);
        if (elen == 0) {
            if (highlight) write_warn(str, underline);
            write_warn_str(str, epath);
            if (highlight) write_warn(str, reset);
            write_warn(str, "\n");
        }
        else {
            write_warn_str(str, emesg);
            write_warn(str, "\n");
        }
    }
}

VALUE
rb_decorate_message(const VALUE eclass, const VALUE emesg, int highlight)
{
    const char *einfo = "";
    long elen = 0;

    VALUE str = rb_str_new2("");

    if (!NIL_P(emesg)) {
        einfo = RSTRING_PTR(emesg);
        elen = RSTRING_LEN(emesg);
    }
    if (eclass == rb_eRuntimeError && elen == 0) {
        if (highlight) write_warn(str, underline);
        write_warn(str, "unhandled exception");
        if (highlight) write_warn(str, reset);
    }
    else {
        VALUE epath;

        epath = rb_class_name(eclass);
        if (elen == 0) {
            if (highlight) write_warn(str, underline);
            write_warn_str(str, epath);
            if (highlight) write_warn(str, reset);
        }
        else {
            /* emesg is a String instance */
            const char *tail = 0;

            if (highlight) write_warn(str, bold);
            if (RSTRING_PTR(epath)[0] == '#')
                epath = 0;
            if ((tail = memchr(einfo, '\n', elen)) != 0) {
                write_warn2(str, einfo, tail - einfo);
                tail++;		/* skip newline */
            }
            else {
                write_warn_str(str, emesg);
            }
            if (epath) {
                write_warn(str, " (");
                if (highlight) write_warn(str, underline);
                write_warn_str(str, epath);
                if (highlight) {
                    write_warn(str, reset);
                    write_warn(str, bold);
                }
                write_warn2(str, ")", 1);
                if (highlight) write_warn(str, reset);
            }
            if (tail && einfo+elen > tail) {
                if (!highlight) {
                    write_warn2(str, "\n", 1);
                    write_warn2(str, tail, einfo+elen-tail);
                }
                else {
                    elen -= tail - einfo;
                    einfo = tail;
                    write_warn2(str, "\n", 1);
                    while (elen > 0) {
                        tail = memchr(einfo, '\n', elen);
                        if (!tail || tail > einfo) {
                            write_warn(str, bold);
                            write_warn2(str, einfo, tail ? tail-einfo : elen);
                            write_warn(str, reset);
                            if (!tail) {
                                break;
                            }
                        }
                        elen -= tail - einfo;
                        einfo = tail;
                        do ++tail; while (tail < einfo+elen && *tail == '\n');
                        write_warn2(str, einfo, tail-einfo);
                        elen -= tail - einfo;
                        einfo = tail;
                    }
                }
            }
        }
    }

    return str;
}

static void
print_backtrace(const VALUE eclass, const VALUE errat, const VALUE str, int reverse, long backtrace_limit)
{
    if (!NIL_P(errat)) {
        long i;
        long len = RARRAY_LEN(errat);
        const int threshold = 1000000000;
        int width = (len <= 1) ? INT_MIN : ((int)log10((double)(len > threshold ?
                                         ((len - 1) / threshold) :
                                         len - 1)) +
                     (len < threshold ? 0 : 9) + 1);

        long skip_start = -1, skip_len = 0;

        // skip for stackoverflow
        if (eclass == rb_eSysStackError) {
            long trace_head = 9;
            long trace_tail = 4;
            long trace_max = trace_head + trace_tail + 5;
            if (len > trace_max) {
                skip_start = trace_head;
                skip_len = len - trace_max + 5;
            }
        }

        // skip for explicit limit
        if (backtrace_limit >= 0 && len > backtrace_limit + 2) {
            skip_start = backtrace_limit + 1;
            skip_len = len - skip_start;
        }

        for (i = 1; i < len; i++) {
            if (i == skip_start) {
                write_warn_str(str, rb_sprintf("\t ... %ld levels...\n", skip_len));
                i += skip_len;
                if (i >= len) break;
            }
            VALUE line = RARRAY_AREF(errat, reverse ? len - i : i);
            if (RB_TYPE_P(line, T_STRING)) {
                VALUE bt = rb_str_new_cstr("\t");
                if (reverse) rb_str_catf(bt, "%*ld: ", width, len - i);
                write_warn_str(str, rb_str_catf(bt, "from %"PRIsVALUE"\n", line));
            }
        }
    }
}

VALUE rb_get_detailed_message(VALUE exc, VALUE opt);

static int
shown_cause_p(VALUE cause, VALUE *shown_causes)
{
    VALUE shown = *shown_causes;
    if (!shown) {
        *shown_causes = shown = rb_obj_hide(rb_ident_hash_new());
    }
    if (rb_hash_has_key(shown, cause)) return TRUE;
    rb_hash_aset(shown, cause, Qtrue);
    return FALSE;
}

static void
show_cause(VALUE errinfo, VALUE str, VALUE opt, VALUE highlight, VALUE reverse, long backtrace_limit, VALUE *shown_causes)
{
    VALUE cause = rb_attr_get(errinfo, id_cause);
    if (!NIL_P(cause) && rb_obj_is_kind_of(cause, rb_eException) &&
        !shown_cause_p(cause, shown_causes)) {
        volatile VALUE eclass = CLASS_OF(cause);
        VALUE errat = rb_get_backtrace(cause);
        VALUE emesg = rb_get_detailed_message(cause, opt);
        if (reverse) {
            show_cause(cause, str, opt, highlight, reverse, backtrace_limit, shown_causes);
            print_backtrace(eclass, errat, str, TRUE, backtrace_limit);
            print_errinfo(eclass, errat, emesg, str, RTEST(highlight));
        }
        else {
            print_errinfo(eclass, errat, emesg, str, RTEST(highlight));
            print_backtrace(eclass, errat, str, FALSE, backtrace_limit);
            show_cause(cause, str, opt, highlight, reverse, backtrace_limit, shown_causes);
        }
    }
}

void
rb_exc_check_circular_cause(VALUE exc)
{
    VALUE cause = exc, shown_causes = 0;
    do {
        if (shown_cause_p(cause, &shown_causes)) {
            rb_raise(rb_eArgError, "circular causes");
        }
    } while (!NIL_P(cause = rb_attr_get(cause, id_cause)));
}

void
rb_error_write(VALUE errinfo, VALUE emesg, VALUE errat, VALUE str, VALUE opt, VALUE highlight, VALUE reverse)
{
    volatile VALUE eclass;
    VALUE shown_causes = 0;
    long backtrace_limit = rb_backtrace_length_limit;

    if (NIL_P(errinfo))
        return;

    if (UNDEF_P(errat)) {
        errat = Qnil;
    }
    eclass = CLASS_OF(errinfo);
    if (reverse) {
        static const char traceback[] = "Traceback "
            "(most recent call last):\n";
        const int bold_part = rb_strlen_lit("Traceback");
        char buff[sizeof(traceback)+sizeof(bold)+sizeof(reset)-2], *p = buff;
        const char *msg = traceback;
        long len = sizeof(traceback) - 1;
        if (RTEST(highlight)) {
#define APPEND(s, l) (memcpy(p, s, l), p += (l))
            APPEND(bold, sizeof(bold)-1);
            APPEND(traceback, bold_part);
            APPEND(reset, sizeof(reset)-1);
            APPEND(traceback + bold_part, sizeof(traceback)-bold_part-1);
#undef APPEND
            len = p - (msg = buff);
        }
        write_warn2(str, msg, len);
        show_cause(errinfo, str, opt, highlight, reverse, backtrace_limit, &shown_causes);
        print_backtrace(eclass, errat, str, TRUE, backtrace_limit);
        print_errinfo(eclass, errat, emesg, str, RTEST(highlight));
    }
    else {
        print_errinfo(eclass, errat, emesg, str, RTEST(highlight));
        print_backtrace(eclass, errat, str, FALSE, backtrace_limit);
        show_cause(errinfo, str, opt, highlight, reverse, backtrace_limit, &shown_causes);
    }
}

static void
rb_ec_error_print_detailed(rb_execution_context_t *const ec, const VALUE errinfo, const VALUE str, VALUE emesg0)
{
    volatile uint8_t raised_flag = ec->raised_flag;
    volatile VALUE errat = Qundef;
    volatile bool written = false;
    volatile VALUE emesg = emesg0;

    VALUE opt = rb_hash_new();
    VALUE highlight = rb_stderr_tty_p() ? Qtrue : Qfalse;
    rb_hash_aset(opt, ID2SYM(rb_intern_const("highlight")), highlight);

    if (NIL_P(errinfo))
        return;
    rb_ec_raised_clear(ec);

    EC_PUSH_TAG(ec);
    if (EC_EXEC_TAG() == TAG_NONE) {
        errat = rb_get_backtrace(errinfo);
    }
    if (UNDEF_P(emesg)) {
        emesg = Qnil;
        emesg = rb_get_detailed_message(errinfo, opt);
    }

    if (!written) {
        written = true;
        rb_error_write(errinfo, emesg, errat, str, opt, highlight, Qfalse);
    }

    EC_POP_TAG();
    ec->errinfo = errinfo;
    rb_ec_raised_set(ec, raised_flag);
}

void
rb_ec_error_print(rb_execution_context_t *volatile ec, volatile VALUE errinfo)
{
    rb_ec_error_print_detailed(ec, errinfo, Qnil, Qundef);
}

#define undef_mesg_for(v, k) rb_fstring_lit("undefined"v" method `%1$s' for "k" `%2$s'")
#define undef_mesg(v) ( \
        is_mod ? \
        undef_mesg_for(v, "module") : \
        undef_mesg_for(v, "class"))

void
rb_print_undef(VALUE klass, ID id, rb_method_visibility_t visi)
{
    const int is_mod = RB_TYPE_P(klass, T_MODULE);
    VALUE mesg;
    switch (visi & METHOD_VISI_MASK) {
      case METHOD_VISI_UNDEF:
      case METHOD_VISI_PUBLIC:    mesg = undef_mesg(""); break;
      case METHOD_VISI_PRIVATE:   mesg = undef_mesg(" private"); break;
      case METHOD_VISI_PROTECTED: mesg = undef_mesg(" protected"); break;
      default: UNREACHABLE;
    }
    rb_name_err_raise_str(mesg, klass, ID2SYM(id));
}

void
rb_print_undef_str(VALUE klass, VALUE name)
{
    const int is_mod = RB_TYPE_P(klass, T_MODULE);
    rb_name_err_raise_str(undef_mesg(""), klass, name);
}

#define inaccessible_mesg_for(v, k) rb_fstring_lit("method `%1$s' for "k" `%2$s' is "v)
#define inaccessible_mesg(v) ( \
        is_mod ? \
        inaccessible_mesg_for(v, "module") : \
        inaccessible_mesg_for(v, "class"))

void
rb_print_inaccessible(VALUE klass, ID id, rb_method_visibility_t visi)
{
    const int is_mod = RB_TYPE_P(klass, T_MODULE);
    VALUE mesg;
    switch (visi & METHOD_VISI_MASK) {
      case METHOD_VISI_UNDEF:
      case METHOD_VISI_PUBLIC:    mesg = inaccessible_mesg(""); break;
      case METHOD_VISI_PRIVATE:   mesg = inaccessible_mesg("private"); break;
      case METHOD_VISI_PROTECTED: mesg = inaccessible_mesg("protected"); break;
      default: UNREACHABLE;
    }
    rb_name_err_raise_str(mesg, klass, ID2SYM(id));
}

static int
sysexit_status(VALUE err)
{
    VALUE st = rb_ivar_get(err, id_status);
    return NUM2INT(st);
}

enum {
    EXITING_WITH_MESSAGE = 1,
    EXITING_WITH_STATUS = 2,
    EXITING_WITH_SIGNAL = 4
};
static int
exiting_split(VALUE errinfo, volatile int *exitcode, volatile int *sigstatus)
{
    int ex = EXIT_SUCCESS;
    VALUE signo;
    int sig = 0;
    int result = 0;

    if (NIL_P(errinfo)) return 0;

    if (THROW_DATA_P(errinfo)) {
        int throw_state = ((const struct vm_throw_data *)errinfo)->throw_state;
        ex = throw_state & VM_THROW_STATE_MASK;
        result |= EXITING_WITH_STATUS;
    }
    else if (rb_obj_is_kind_of(errinfo, rb_eSystemExit)) {
        ex = sysexit_status(errinfo);
        result |= EXITING_WITH_STATUS;
    }
    else if (rb_obj_is_kind_of(errinfo, rb_eSignal)) {
        signo = rb_ivar_get(errinfo, id_signo);
        sig = FIX2INT(signo);
        result |= EXITING_WITH_SIGNAL;
        /* no message when exiting by signal */
        if (signo == INT2FIX(SIGSEGV) || !rb_obj_is_instance_of(errinfo, rb_eSignal))
            /* except for SEGV and subclasses */
            result |= EXITING_WITH_MESSAGE;
    }
    else if (rb_obj_is_kind_of(errinfo, rb_eSystemCallError) &&
        FIXNUM_P(signo = rb_attr_get(errinfo, id_signo))) {
        sig = FIX2INT(signo);
        result |= EXITING_WITH_SIGNAL;
        /* no message when exiting by error to be mapped to signal */
    }
    else {
        ex = EXIT_FAILURE;
        result |= EXITING_WITH_STATUS | EXITING_WITH_MESSAGE;
    }

    if (exitcode && (result & EXITING_WITH_STATUS))
        *exitcode = ex;
    if (sigstatus && (result & EXITING_WITH_SIGNAL))
        *sigstatus = sig;

    return result;
}

#define unknown_longjmp_status(status) \
    rb_bug("Unknown longjmp status %d", status)

static int
error_handle(rb_execution_context_t *ec, VALUE errinfo, enum ruby_tag_type ex)
{
    int status = EXIT_FAILURE;

    if (rb_ec_set_raised(ec))
        return EXIT_FAILURE;
    switch (ex & TAG_MASK) {
      case 0:
        status = EXIT_SUCCESS;
        break;

      case TAG_RETURN:
        error_pos(Qnil);
        warn_print("unexpected return\n");
        break;
      case TAG_NEXT:
        error_pos(Qnil);
        warn_print("unexpected next\n");
        break;
      case TAG_BREAK:
        error_pos(Qnil);
        warn_print("unexpected break\n");
        break;
      case TAG_REDO:
        error_pos(Qnil);
        warn_print("unexpected redo\n");
        break;
      case TAG_RETRY:
        error_pos(Qnil);
        warn_print("retry outside of rescue clause\n");
        break;
      case TAG_THROW:
        /* TODO: fix me */
        error_pos(Qnil);
        warn_print("unexpected throw\n");
        break;
      case TAG_RAISE:
        if (!(exiting_split(errinfo, &status, NULL) & EXITING_WITH_MESSAGE)) {
            break;
        }
        /* fallthrough */
      case TAG_FATAL:
        rb_ec_error_print(ec, errinfo);
        break;
      default:
        unknown_longjmp_status(ex);
        break;
    }
    rb_ec_reset_raised(ec);
    return status;
}
