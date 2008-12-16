# Before `make install' is performed this script should be runnable with
# `make test'. After `make install' it should work as `perl DBIx-bind_param_inline.t'

use DBI;

#########################

# change 'tests => 1' to 'tests => last_test_to_print';

use Test::More tests => 2;
BEGIN { use_ok('DBIx::bind_param_inline') };


#########################

# Insert your test code below, the Test::More module is use()ed here so read
# its man page ( perldoc Test::More ) for help writing this test script.

my $dbh = DBI->connect('dbi:NullP:','','');

our ($foo, $bar, $baz);


  # qq style -- escape rods of Asclepius
  my $sth = prepare_inline($dbh, <<SQL);
  SELECT * from mytable WHERE foo = \$foo AND bar = \$bar AND baz = \$baz
SQL
  # q style -- noninterpolative
  my $sth2 = prepare_inline($dbh, <<'SQL');
  INSERT INTO mytable (foo, bar, baz) VALUES ($foo, $bar, $baz)
SQL
    ($foo, $bar, $baz) = (27, 33, 41);
  $sth2->execute(); #placeholders get bound for you
  
$sth->execute;
my @ary = $sth->fetchrow_array;
print @ary,"\n";
ok(1);
