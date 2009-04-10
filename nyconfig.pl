#!/usr/bin/perl


use strict; use warnings; 

my $template = "mall.txt";
my $deploy_dir; my $log_path;

my @apache_dirs = ('/etc/apache2/sites-enabled/','/etc/httpd/sites/');
my @log_dirs = ('/var/log/httpd','/var/log/apache2');

my $virtual_dir = "/var/www/virtual/";

sub next_number
{

        my $some_dir = $_[0];
        opendir(DIR, $some_dir) || die "can opendir $some_dir: $!";
        my @dots = grep { /^\d/ &&   "$some_dir/$_" } readdir(DIR);
        closedir DIR;
        my $num =  (reverse sort @dots)[0];
        if ($num  =~ /(\d*).*/ )
             {  
                $num = $1;
                $num++;
                $num = sprintf("%03d", $num);
             }
        return $num;
}

main:
{
	foreach (@apache_dirs) 	{ if (-e) { $deploy_dir .= $_ }; }
	unless ($deploy_dir) { die "no matching apache dir in " . join(',',@apache_dirs) }
	print "Apache config: $deploy_dir\n";
				
	foreach (@log_dirs) 	{ if (-e) { $log_path .= $_ }; }
	unless ($log_path) { die "no matching log dir in " . join(',',@log_dirs) }
	print "Log config: $log_path\n";

	die "need a parameter"  unless (my $domain = $ARGV[0]);
	my $number = &next_number($deploy_dir);
	die "$domain.conf already exist!"  if (-e $deploy_dir . $number . '-'. $domain . '.conf');

	die "$domain dir already exist!"  if (-e  $virtual_dir . $domain);

	# $domain = "kers.se";

	open INF, $template;
	open UTF, '>'. $deploy_dir . $number . '-' .  $domain . '.conf';
	while (<INF>)
	{
		s/DOMAIN/$domain/g;				
		s/LOGDIR/$log_path/g;				
		print UTF;
	}	

	die "can not create dir $!" unless mkdir $virtual_dir . $domain;

	
	close INF; 
	close UTF;
}

