use v6;
use lib 'lib';
use Text::Markdown::Discount;
use Test;

is markdown-to-html("_BLORG_"), '<p><em>BLORG</em></p>', "emphasized paragraph, simple interface";
is markdown-to-html("__BLORG__"), '<p><strong>BLORG</strong></p>', "strong paragraph, simple interface";
is markdown-to-html("[foo](www.google.com)"), '<p><a href="www.google.com">foo</a></p>', "linkify, simple interface";

is markdown-to-html("[foo](www.google.com)", <no-links>), '<p>[foo](www.google.com)</p>', "no-links flag, simple interface";

my $simple-doc = MMIOT.new("_BLORG_");
is $simple-doc.html, '<p><em>BLORG</em></p>', "emphasized paragraph, OO interface";

is $simple-doc.gist, '<p><em>BLORG</em></p>', "emphasized paragraph, OO interface, gist";

my $text-with-header = slurp "t/title-author-date.md";
my $doc-with-header = MMIOT.new($text-with-header);

is $doc-with-header.title, "Parsing Markdown with Discount and Perl 6", "document title";
is $doc-with-header.author, "Camelia", "document author";
is $doc-with-header.date, "September, 2014", "document date";

done;
