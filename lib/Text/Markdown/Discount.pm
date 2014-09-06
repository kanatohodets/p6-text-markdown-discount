use v6;
use NativeCall;

my class MMIOT is repr('CPointer') { }

# hack to be able to access the buffer contents after discount performs
# mkd_document.
my class StringBuf is repr('CStruct') {
    has Str $.text;
}

sub mkd_string(Str, int, int) returns MMIOT is native("libmarkdown") { ... }
sub mkd_compile(MMIOT, int) returns int is native("libmarkdown") { ... }
sub mkd_document(MMIOT, StringBuf) returns int is native("libmarkdown") { ... }

sub markdown-to-html(Str $markdown) is export {
    my $doc = mkd_string($markdown, $markdown.chars, 0);
    my $res = mkd_compile($doc, 0);
    my $output := StringBuf.new();
    #takes a MMIOT pointer plus a **char buffer
    $res = mkd_document($doc, $output);
    return $output.text;
}
