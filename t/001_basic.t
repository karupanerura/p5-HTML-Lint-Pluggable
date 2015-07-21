#!perl -w
use strict;
use warnings;
use utf8;
use Test::More;

use HTML::Lint::Pluggable;

my $html5 = q{
<html>
<head><title>hoge</title></head>
<body><h1 data-fuga="hoge" xxx="yyy">hoge</h1><footer>exeeee</footer></body>
</html>
};

my $passing_html5 = q{
<html>
<head><title>Test</title></head>
<body>
<div tabindex="42"></div>
<div translate="no">Test</div>
</body>
</html>
};

my $has_entites_html = q{
<html>
<head><title>hoge</title></head>
<body><h1>やまだ&</h1></body>
</html>
};

my $has_entites_html5 = q{
<html>
<head><title>hoge</title></head>
<body><h1 data-fuga="hoge" xxx="yyy">やまだ&</h1><footer>exeeee</footer></body>
</html>
};

subtest 'html5' => sub {
    subtest 'default' => sub {
        my $lint = HTML::Lint::Pluggable->new;
        $lint->parse($html5);
        is scalar($lint->errors), 3;
    };

    subtest 'load HTML5' => sub {
        my $lint = HTML::Lint::Pluggable->new;
        $lint->load_plugins(qw/HTML5/);
        $lint->parse($html5);
        is scalar($lint->errors), 1;
    };

    subtest 'default back' => sub {
        my $lint = HTML::Lint::Pluggable->new;
        $lint->parse($html5);
        is scalar($lint->errors), 3;
    };

    subtest 'passing html5' => sub {
        my $lint = HTML::Lint::Pluggable->new;
        $lint->load_plugins(qw/HTML5/);
        $lint->parse($passing_html5);
        use Data::Dumper;
        say STDERR Dumper($lint->errors);
        is scalar($lint->errors), 0;
    }
};

subtest 'tiny entities escape rule' => sub {
    local $SIG{__WARN__} = sub {};
    subtest 'default' => sub {
        my $lint = HTML::Lint::Pluggable->new;
        $lint->parse($has_entites_html);
        is scalar($lint->errors), 4;
    };

    subtest 'load TinyEntitesEscapeRule' => sub {
        my $lint = HTML::Lint::Pluggable->new;
        $lint->load_plugins(qw/TinyEntitesEscapeRule/);
        $lint->parse($has_entites_html);
        is scalar($lint->errors), 1;
    };

    subtest 'default back' => sub {
        my $lint = HTML::Lint::Pluggable->new;
        $lint->parse($has_entites_html);
        is scalar($lint->errors), 4;
    };
};

subtest 'html5 and tiny entities escape rule' => sub {
    local $SIG{__WARN__} = sub {};
    subtest 'default' => sub {
        my $lint = HTML::Lint::Pluggable->new;
        $lint->parse($has_entites_html5);
        is scalar($lint->errors), 7;
    };

    subtest 'load TinyEntitesEscapeRule and HTML5' => sub {
        my $lint = HTML::Lint::Pluggable->new;
        $lint->load_plugins(qw/TinyEntitesEscapeRule HTML5/);
        $lint->parse($has_entites_html5);
        is scalar($lint->errors), 2;
    };

    subtest 'default back' => sub {
        my $lint = HTML::Lint::Pluggable->new;
        $lint->parse($has_entites_html5);
        is scalar($lint->errors), 7;
    };
};

done_testing;
