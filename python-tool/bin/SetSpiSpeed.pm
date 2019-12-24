package SetSpiSpeed;
#
# @brief    Set spi speed for project configuration
# @version  ver.1.0
# @date     Mon Aug 22 16:09:02 CEST 2016
# @company  Frobas IT Department, www.frobas.com 2016
# @author   Vladimir Roncevic <vladimir.roncevic@frobas.com>
#
use 5.018002;
use strict;
use warnings;
use Exporter;
use XML::Simple;
use Text::Table;
use File::Basename qw(dirname);
use Cwd qw(abs_path);
use lib dirname(dirname(abs_path($0))) . '/../../lib/perl5';
use Status;
our @ISA = qw(Exporter);
our %EXPORT_TAGS = ('all' => [qw()]);
our @EXPORT_OK = (@{$EXPORT_TAGS{'all'}});
our @EXPORT = qw(setspispeed);
our $VERSION = '1.0';
our $TOOL_DBG = "false";

#
# @brief   Set spi speed for project configuration
# @params  Values required argument structure and option [output]
# @retval  Success 0, else 1
#
# @usage
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
# 
# use SetSpiSpeed qw(setspispeed);
#
# ...
#
# my $status = setspispeed(\%argStructure, \$option);
#
# if ($status == $SUCCESS) {
#	# true
#	# notify admin | user
# } else {
#	# false
#	# return $NOT_SUCCESS
#	# or
#	# exit 128
# }
#
sub setspispeed {
	my $fCaller = (caller(0))[3];
	my $msg = "None";
	my %argStructure = %{$_[0]};
	my $option = $_[1];
	if(%argStructure) {
		my $xmlfh = XML::Simple->new();
		my $toolHome = dirname(dirname(abs_path($0)));
		my $toolCfg = "$toolHome/conf";
		my $xmlBoot = "$argStructure{PREFERENCES}->{SET_PRO_SPI_SPEED}";
		my $xmlBootCfg = "$toolCfg/$xmlBoot";
		my $xmlBootOptions = $xmlfh->XMLin($xmlBootCfg);
		my $table = Text::Table->new(
			"Option",
			"SPI Speed"
		);
		foreach my $key (keys(%{$xmlBootOptions->{firmware}})) {
			my $spiSpeedOption = $xmlBootOptions->{firmware}{$key}{option};
			my $spiSpeed = $xmlBootOptions->{firmware}{$key}{speed};
			if($spiSpeedOption eq "0") {
				$spiSpeedOption = "$spiSpeedOption (default)";
			}
			$table->add(
				$spiSpeedOption,
				$spiSpeed . " MHz"
			);
		}
		$table->add(' ');
		print($table);
		my $decision = <STDIN>;
		chop($decision);
		foreach my $key (keys(%{$xmlBootOptions->{firmware}})) {
			if($decision eq "$xmlBootOptions->{firmware}{$key}{option}") {
				${$option} = $xmlBootOptions->{firmware}{$key}{speed};
			} else {
				${$option} = "20";
			}
		}
		$msg = "Done";
		if("$TOOL_DBG" eq "true") {
			print("[Info] " . $fCaller . " " . $msg . "\n");
		}
		return ($SUCCESS);
	}
	$msg = "Check argument [ARGUMENT_STRUCTURE]";
    print("[Error] " . $fCaller . " " . $msg . "\n");
	return ($NOT_SUCCESS);
} 

1;
__END__

=head1 NAME

SetSpiSpeed - Set spi speed for project configuration

=head1 SYNOPSIS

	use SetSpiSpeed qw(setspispeed);

	...

	my $status = setspispeed(\%argStructure, \$option);

	if ($status == $SUCCESS) {
		# true
		# notify admin | user
	} else {
		# false
		# return $NOT_SUCCESS
		# or
		# exit 128
	}

=head1 DESCRIPTION 

Set spi speed for project configuration

=head2 EXPORT

setspispeed - return 0 for success, else return 1

=head1 AUTHOR

Vladimir Roncevic, E<lt>vladimir.roncevic@frobas.comE<gt>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2016 by www.frobas.com 

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself, either Perl version 5.18.2 or,
at your option, any later version of Perl 5 you may have available.

=cut