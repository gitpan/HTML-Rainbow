# 01-method.t
#
# Test suite for HTML::Rainbow
# Test the module methods
#
# copyright (C) 2005 David Landgren

use strict;

eval qq{use Test::More tests => 11};
if( $@ ) {
    warn "# Test::More not available, no tests performed\n";
    print "1..1\nok 1\n";
    exit 0;
}

use HTML::Rainbow;

my $Unchanged = 'The scalar remains the same';
$_ = $Unchanged;

{
	# check clipping, min/max swapping, and percents
	my $r = HTML::Rainbow->new(
		max      => 400,
		min      => -10,
		green    => 245,
		blue_max => '25%',
		blue_min => '75%',
	);

	cmp_ok( tied($r->{red  })->max, '==', 255, 'red max clipped' );
	cmp_ok( tied($r->{red  })->min, '==',   0, 'red min clipped' );
	cmp_ok( tied($r->{green})->max, '==', 245, 'green max fixed' );
	cmp_ok( tied($r->{green})->min, '==', 245, 'green min fixed' );
	cmp_ok( tied($r->{blue })->max, '==', 191, 'blue max percent swapped ok' );
	cmp_ok( tied($r->{blue })->min, '==',  63, 'blue min percent swapped ok' );
}

{
	# check output: clamp period_list to one period to avoid randomness
	my $r = HTML::Rainbow->new(
		max => 220,
		min =>  20,
		period_list => [qw[10]],
	);

	cmp_ok( $r->rainbow( 'maijstral' ), 'eq',
	'<font color="#787878">m</font><font color="#b2b2b2">a</font><font color="#d7d7d7">i</font><font color="#d7d7d7">j</font><font color="#b2b2b2">s</font><font color="#777777">t</font><font color="#3d3d3d">r</font><font color="#181818">a</font><font color="#181818">l</font>',
	q{rainbow 'maijstral'},
	);

	cmp_ok( $r->rainbow( 'mondaugen' ), 'eq',
	'<font color="#3d3d3d">m</font><font color="#787878">o</font><font color="#b2b2b2">n</font><font color="#d7d7d7">d</font><font color="#d7d7d7">a</font><font color="#b2b2b2">u</font><font color="#777777">g</font><font color="#3d3d3d">e</font><font color="#181818">n</font>',
	q{rainbow 'mondaugen'},
	);
}

like( HTML::Rainbow->new(use_span=>1)->rainbow( 'stencil' ),
	qr{^(?:<span style="color:#[\da-f]{6}">[stencil]</span>){7}$},
	'span element'
);

like( HTML::Rainbow->new->rainbow( 'a b' ),
	qr{^<font color="#[\da-f]{6}">a</font> <font color="#[\da-f]{6}">b</font>},
	'skip space'
);

cmp_ok( $_, 'eq', $Unchanged, '$_ has not been altered' );
