# 00-basic.t
#
# Test suite for HTML::Rainbow
# Make sure the basic stuff works
#
# copyright (C) 2005 David Landgren

use strict;

eval qq{ use Test::More tests => 7 };
if( $@ ) {
    warn "# Test::More not available, no tests performed\n";
    print "1..1\nok 1\n";
    exit 0;
}

use HTML::Rainbow;

my $Unchanged = 'The scalar remains the same';
$_ = $Unchanged;

diag( "testing HTML::Rainbow v$HTML::Rainbow::VERSION" );

{
    my $t = HTML::Rainbow->new;
    ok( defined($t), 'new() defines ...' );
    ok( ref($t) eq 'HTML::Rainbow', '... a HTML::Rainbow object' );
}

SKIP: {
    skip( 'Test::Pod not installed on this system', 3 )
        unless do {
            eval "use Test::Pod";
            $@ ? 0 : 1;
        };

    pod_file_ok( 'Rainbow.pm' );
    pod_file_ok( 'eg/rainbow.pl' );
    pod_file_ok( 'eg/html-parse' );
}

SKIP: {
    skip( 'Test::Pod::Coverage not installed on this system', 1 )
        unless do {
            eval "use Test::Pod::Coverage";
            $@ ? 0 : 1;
        };
    pod_coverage_ok( 'HTML::Rainbow', 'POD coverage is go!' );
}

cmp_ok( $_, 'eq', $Unchanged, '$_ has not been altered' );
