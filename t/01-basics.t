use v6;
use lib 'lib';
use Text::Markdown::Discount;
use Test;

is markdown-to-html("_BLORG_"), '<p><em>BLORG</em></p>', "emphasized/italic paragraph";
is markdown-to-html("__BLORG__"), '<p><strong>BLORG</strong></p>', "strong/bold paragraph";
