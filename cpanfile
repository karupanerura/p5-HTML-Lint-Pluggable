requires 'Carp';
requires 'Class::Load';
requires 'HTML::Entities';
requires 'HTML::Lint';
requires 'Hash::Util::FieldHash';
requires 'List::MoreUtils';
requires 'parent';
requires 'perl', '5.009_004';

on configure => sub {
    requires 'Module::Build::Pluggable', '0.04';
    requires 'Module::Build::Pluggable::ReadmeMarkdownFromPod', '0.04';
    requires 'Module::Build::Pluggable::Repository', '0.01';
};

on build => sub {
    requires 'Module::Build::Pluggable::ReadmeMarkdownFromPod', '0.04';
    requires 'Module::Build::Pluggable::Repository', '0.01';
    requires 'Pod::Markdown';
};

on test => sub {
    requires 'Test::More', '0.88';
    requires 'Test::Requires', '0.06';
};