#!/usr/bin/perl

#UKMAA Manager

use DBI;
use Switch;
use Term::ANSIScreen qw(cls);




#Main Program
main();



sub main {
  connect_sql();
 view_menu();
 exit;
}




sub view_menu {
my $numb_members=count_members();
cls();
print "==========================================================================\n";
print "|                                                                        |\n";
print "|                          UKMAA Manager                                 |\n";
print "|                                                                        |\n";
print "=========================================================================\n\n";
print "                      Total Number of members: $numb_members\n\n";

print "                <N>.. Enter New Association Member \n";
print "                <E>.. Edit Existing Member         \n";
print "                <L>.. List All Members             \n";
print "\n\n";
print "                <D>.. Database Manager             \n";
print "                <Q>.. Quit Program                 \n";
get_selection();
}

sub get_selection {
my $selection = "";
print "\n\n";
print "Please enter your selection -> ";
$selection = <STDIN>;
chomp($selection);
$selection = uc($selection);

switch($selection) {
	case "Q"  {exit;}
	case "D" {system("./ukmaa_db_manager.pl");}
	case "N" {new_member();}
	case "E" {edit_member();}
  case "L" {list_all_members()}
  else {view_menu();}
}

return 0;
}

#Connect to SQLlite
sub connect_sql {
#Connect to DB:
our $db_name = "ukmaa_data.dbl";
our $dbh = DBI->connect("dbi:SQLite:$db_name") || die "Cannot connect: $DBI::errstr";
}

#Add New Member
sub new_member {
cls();
print "==========================================================================\n";
print "|                  Add New Association Member to Database                |\n";
print "==========================================================================\n";
print "\n\n";
#Declare Variables
print "Adding new member to the UKMAA Member Database...\n";
print "Please enter all information, or put N/A if it does not apply...\n";
print "\n\n";
print "FIRST name: "; my $first_name = <STDIN>;
print "LAST name: "; my $last_name = <STDIN>;
print "Association Number: "; my $assoc_number=<STDIN>;
print "Address: "; my $address = <STDIN>;
print "City: "; my $city = <STDIN>;
print "State (e.g TX): "; my $state=<STDIN>;
print "Zip Code: "; my $zip=<STDIN>;
print "Birth Date (mm/dd/yy): "; my $dob=<STDIN>;
print "E-Mail Address: "; my $email=<STDIN>;
print "Contact Phone (xxx-xxx-xxxx): "; my $phone=<STDIN>;
print "Current Rank: "; my $current_rank=<STDIN>;
print "Last Test Date (mm/dd/yy): "; my $last_test=<STDIN>;
print "Current Instructor: "; my $current_instructor=<STDIN>;
print "Date Joined: "; my $date_joined=<STDIN>;
print "Studio ID: "; my $studio_id=<STDIN>;
print "Style(s) Preformed: "; my $styles=<STDIN>;
print "Other Associations/Federations belonged to: "; my $other_assoc=<STDIN>;
print "General Notes: "; my $notes=<STDIN>;

chomp($first_name); chomp($last_name); chomp($assoc_number); chomp($address); chomp($city); chomp($state); chomp($zip); chomp($dob); chomp($email); chomp($phone); chomp($current_rank);
chomp($last_test); chomp($current_instructor); chomp($date_joined); chomp($studio_id); chomp($styles); chomp($other_assoc); chomp($notes);

#Veiew and verify entry
cls();
print "\n\n\n";
print("=========================================================================\n");
printf("%30s","Viewing Association ID: $assoc_number\n");
print("=========================================================================\n\n");
print "--------------------------------------------------------------------------\n";
print "Section 1: Student Information\n\n";
print "--------------------------------------------------------------------------\n";
printf("%-30s", "\rFirst Name: $first_name"); printf("%-30s", "Last Name: $last_name\n");
printf("%-30s", "\rAddress: $address"); printf("%-30s", "City: $city\n");
printf("%-30s", "\rState: $state"); printf("%-30s", "Zip: $zip\n");
printf("%-30s", "\rBirth Date: $dob"); printf("%-30s", "E-Mail Address:$email\n");
printf("%-30s", "\rContact Phone: $phone\n");

print "\n\n";
print "--------------------------------------------------------------------------\n";
print "Section 2: Rank & Style Information\n\n";
print "--------------------------------------------------------------------------\n";
printf("%-25s", "\rCurrent Rank: $currenk_rank"); printf("%-25s", "Current Instructor: $current_instructor\n");
printf("%-25s", "\rLast Test Date: $last_test"); printf("%-25s", "Date Joined: $date_joined\n");
printf("%-25s", "\rStudio ID: $studio_id\n");
printf("%-30s", "\rStyle(s) Preformed: $styles\n");
printf("%-30s", "\rOther Associations/Federations: $other_assoc\n");
print "\n\n";
print "--------------------------------------------------------------------------\n";
print "Section 3: Notes\n\n";
print "--------------------------------------------------------------------------\n";
printf("%-70s", "\rNotes: $notes\n");
print "\n";
print "Is all the above information correct?  (y/n/q) "; my $answer = <STDIN>;
chomp($answer);
$answer=uc($answer);
switch ($answer) {
    case "N"  {new_member();}
    case "Y"  {

      #Insert Into SQLite
       my $sth = $dbh->prepare("INSERT INTO members VALUES ('$assoc_number', '$first_name', '$last_name', '$address', '$city', '$state', '$zip', '$birth_date', '$email', '$phone', '$current_rank', '$last_test', '$current_instructor', '$date_joined', '$studio_id', '$styles', '$other_assoc', '$notes')");
       $sth->execute() or die "Association Member Addition Failed to add to database - error: $dbh->errstr()";
       print "\n\n";
       print "Added $first_name $last_name to the UKMAA database. Press any key to return to menu...";  <STDIN>;
       view_menu();
    }
    case "Q" {view_menu();}
    else {print "Invalid entry, try again. <STDIN>;"}

    }

}




sub count_members {
  #Count the total number of members in the member database
  my $numb_members = 0;
  my $sth = $dbh->prepare("SELECT * FROM members");
  $sth->execute();
  while (my $ref = $sth->fetchrow_hashref()) {
    $numb_members = $numb_members + 1;
  }

  return $numb_members;

}
