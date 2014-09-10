use v6;
use NativeCall;

my @flags = <
    no-links
    no-image
    no-pants
    no-html
    strict
    tagtext
    no-extensions
    cdata
    no-superscript
    no-relaxed
    no-tables
    no-strikethrough
    toc
    one-compat
    auto-link
    safe-link
    no-header
    tabstop
    no-div-quote
    no-alphalist
    no-definition-list
    extra-footnote
    no-style
>;

# set up the link between the flag names and the numbers Discount expects.
# (the ordering of the above list is important)
my %flag-mapping = @flags.kv.map(-> $index, $flag {$flag => 2 ** $index});

my sub flags(*@flags) {
    my $flag-mask = 0;
    for @flags -> $flag-name {
        if $flag-name {
            if %flag-mapping{$flag-name}:exists {
                $flag-mask +|= %flag-mapping{$flag-name};
            } else {
                die "unknown discount flag name \"$flag-name\". \nValid flags: \n\t{%flag-mapping.keys.join("\n\t")}";
            }
        }
    }

    return $flag-mask;
}

# 'Magic Markdown IO Thing'
class MMIOT is repr('CPointer') {
    # hack to be able to access the buffer contents after discount works on it
    my class StringBuf is repr('CStruct') {
        has Str $.text;
    }

    sub mkd_string(Str, int, int) returns MMIOT is native("libmarkdown") { ... };
    sub mkd_compile(MMIOT, int) returns int is native("libmarkdown") { ... };
    sub mkd_document(MMIOT, StringBuf) returns int is native("libmarkdown") { ... };
    sub mkd_css(MMIOT, StringBuf) returns int is native("libmarkdown") { ... };
    sub mkd_toc(MMIOT, StringBuf) returns int is native("libmarkdown") { ... };
    sub mkd_cleanup(MMIOT) is native("libmarkdown") { ... };

    sub mkd_doc_title(MMIOT) returns Str is native("libmarkdown") { ... };
    sub mkd_doc_author(MMIOT) returns Str is native("libmarkdown") { ... };
    sub mkd_doc_date(MMIOT) returns Str is native("libmarkdown") { ... };

    method new (Str $markdown-text, *@flags) {
        my $flag-mask = flags(@flags);
        my $doc = mkd_string($markdown-text, $markdown-text.chars, $flag-mask);
        my $res = mkd_compile($doc, $flag-mask);
        $doc;
    }

    submethod DESTROY () {
        mkd_cleanup(self);
    }

    method gist () { self.html }

    method !call-with-buffer (&discount-function) {
        my $buf = StringBuf.new();
        my $res = &discount-function.(self, $buf);
        return '' if !$buf.text;
        return $buf.text;
    }

    method html () { self!call-with-buffer(&mkd_document) }
    method toc () { self!call-with-buffer(&mkd_toc) }
    method style () { self!call-with-buffer(&mkd_css) }

    method title () { mkd_doc_title(self) or '' }
    method author () { mkd_doc_author(self) or '' }
    method date () { mkd_doc_date(self) or '' }
}

multi sub markdown-to-html (Str $markdown, Str :flags($flag) = '') is export {
    my $doc = MMIOT.new($markdown, $flag);
    return $doc.html;
}

multi markdown-to-html (Str $markdown, :@flags = ()) is export {
    my $doc = MMIOT.new($markdown, @flags);
    return $doc.html;
}
