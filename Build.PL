use strict;
use warnings FATAL => 'all';

use Module::Build::Pluggable (
    'Repository',
    (-d '.git' || $ENV{RELEASE_TESTING}) ? 'ReadmeMarkdownFromPod' : (),
);

my $builder = Module::Build::Pluggable->new(
    license              => 'perl',
    dynamic_config       => 0,
    build_requires       => {
        'Test::More'     => '0.88',
        'Test::Requires' => '0.06',
    },
    configure_requires   => {
        'Module::Build'                                   => '0.40',
        'Module::Build::Pluggable'                        => '0.04',
        'Module::Build::Pluggable::ReadmeMarkdownFromPod' => '0.02',
    },
    requires             => {
        perl => '5.009_004',
        'parent'                => 0,
        'Carp'                  => 0,
        'HTML::Lint'            => 0,
        'Class::Load'           => 0,
        'Hash::Util::FieldHash' => 0,
        'List::MoreUtils'       => 0,
        'HTML::Entities'        => 0,
    },
    no_index    => { 'directory' => [ 'inc' ] },
    name        => 'HTML-Lint-Pluggable',
    module_name => 'HTML::Lint::Pluggable',
    test_files => (-d '.git' || $ENV{RELEASE_TESTING}) ? 't/ xt/' : 't/',
    recursive_test_files => 1,
    create_readme  => 1,
    create_license => 1,
);

$builder->create_build_script();
