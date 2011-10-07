use strict;
use warnings;

use Finance::MtGox;
use Test::More;

my $key    = '';
my $secret = '';
if ( $key && $secret ) {
    plan tests => 13;
}
else {
    plan skip_all => "Author only tests";
}

my $mtgox = Finance::MtGox->new({
    key    => $key,
    secret => $secret,
});
ok( $mtgox, 'Finance::MtGox object created' );

# unauthenticated API calls
my $depth = $mtgox->call('getDepth');
is( ref $depth, 'HASH', 'getDepth response is a hashref');
is( $depth->{error}, undef, 'no getDepth errors' );
cmp_ok( scalar @{ $depth->{asks} }, '>', 0, 'MtGox has some ask orders' );
cmp_ok( scalar @{ $depth->{bids} }, '>', 0, 'MtGox has some bid orders' );

# authenticated API calls
my $funds = $mtgox->call_auth('getFunds');
is( ref $funds, 'HASH', 'getFunds response is a hashref');
is( $funds->{error}, undef, 'no getFunds errors' );
cmp_ok( $funds->{usds}, '>', 0, 'getFunds has some USD funds' );
cmp_ok( $funds->{btcs}, '>', 0, 'getFunds has some BTC funds' );

# convenience methods built on the core API
my ( $btcs, $usds ) = $mtgox->balances;
cmp_ok( $usds, '>', 0, 'balances() has some USD funds' );
cmp_ok( $btcs, '>', 0, 'balances() has some BTC funds' );
my $rate = $mtgox->clearing_rate( 'asks', 200, 'BTC' );
cmp_ok( $rate, '>', 0, 'has a BTC ask side clearing rate' );
$rate    = $mtgox->clearing_rate( 'bids',  42, 'USD' );
cmp_ok( $rate, '>', 0, 'has a USD bid side clearing rate' );
