requires 'Class::Load';
requires 'HTML::Entities';
requires 'HTML::Lint';
requires 'List::MoreUtils';
requires 'parent';
requires 'perl', '5.008_001';

on configure => sub {
    requires 'Module::Build::Tiny', '0.035';
};

on test => sub {
    requires 'Test::More';
};
