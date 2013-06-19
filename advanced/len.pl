#!/usr/bin/perl -w
#
use strict;
use warnings;

#For CVS , use following line
#my $VERSION=sprintf("%d.%02d", q$Revision: 1.1.1.1 $ =~ /(\d+)\.(\d+)/);


#program version
my $VERSION="0.1";

my $ApacheDir = "/etc/apache2/sites-enabled"; 
my $VirtualDir = "/var/www/virtual";

my $LenDir = "/etc/len";



sub ErrorMsg 
{
 my $text = shift; 
 return ($text);
}

sub get_last_id 
{
  my $text=shift;
  opendir(DIR, $ApacheDir) || die ("can't opendir " . $ApacheDir.": $!");
  my @dots =   reverse ( sort ( grep { /^\d/ && -f "$ApacheDir/$_" } readdir(DIR) ) );
  closedir DIR;
  my $last = $dots[0];
  chomp($last);
  if ($last =~ /(\d*)/)  { return $1 } else { die &ErrorMsg("Unable get next available free id"); }
}

sub process_template
{ 
  my $templatename = shift;
  my $id = shift;
  my $domain = shift;

  my $virtdir = $VirtualDir . "/" . $domain;


  my $ret;
  open (TEMPLATE, $LenDir ."/templates/". $templatename .".tmpl") or die &ErrorMsg("Unable to open template "). $templatename; 
  while (<TEMPLATE>)  
   {
	my $line = $_; 
	$line =~ s/%SITENAME%/$domain/g;
	$line =~ s/%SITEDIR%/$virtdir/g;
 	$ret .= $line;
   }

  close TEMPLATE;

  mkdir $virtdir or warn &ErrorMsg("Can not create ") . $virtdir .' error: '.  $!;
 
 my $newconf = $ApacheDir . "/" .$id . '-'.$domain.'.conf';
  open (APACHECONF, '>'. $newconf ) or die &ErrorMsg("Can not create ") . $newconf .' error: '.  $!;
 
  print APACHECONF $ret;
  close APACHECONF;

}

main:
{
 my $new_id = &get_last_id;
 $new_id++;
 my $domain = $ARGV[0];
 die &ErrorMsg("No parameter sent") unless ($domain);


# print $new_id;

 &process_template("apache-basic",$new_id,$domain);
}

__END__

=head1 NAME

len - short description of your program

=head1 SYNOPSIS

 how to use your program

=head1 DESCRIPTION

 long description of your program

=head1 SEE ALSO

 need to know things before somebody uses your program

=head1 AUTHOR

 Christian Bolstad

=cut
