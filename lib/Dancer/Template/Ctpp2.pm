package Dancer::Template::Ctpp2;

use strict;
use warnings;
use Dancer::Config 'setting';
use Dancer::ModuleLoader;
use Dancer::FileUtils 'path';

use base 'Dancer::Template::Abstract';

our $VERSION = '0.01';

our $_ctpp2;
our %_cfg;

sub init {
    my ($self) = @_;

    die "HTML::CTPP2 is needed by Dancer::Template::Ctpp2"
      unless Dancer::ModuleLoader->load('HTML::CTPP2');
    
    my %ctpp2_cfg=();

    my $source_charset = $self->config->{source_charset} || undef;
    my $destination_charset = $self->config->{destination_charset} || undef;

#    $_cfg{'include_dir'} = setting('views');

    $_cfg{'compiled'} = $self->config->{compiled} || 0;

    if ($source_charset && $destination_charset) {
	$ctpp2_cfg{'source_charset'} = $source_charset;
	$ctpp2_cfg{'destination_charset'} = $destination_charset;
    }

    my @inc = ("$_cfg{'include_dir'}");

    $_ctpp2 = new HTML::CTPP2(%ctpp2_cfg);

}

sub render($$$) {
    my ($self, $template, $tokens) = @_;

    my $use_bytecode = $_cfg{'compiled'};

    if ($use_bytecode) {
        $template =~ s/tt$/ct2/g;
    }

#    Dancer::Logger->debug("use_bytecode: '".$use_bytecode."'");

    die "'$template' is not a regular file"
      if !ref($template) && (!-f $template);

    my $b;

    if ($use_bytecode) {
#	Dancer::Logger->debug("Bytecode: ".$template);
	$b = $_ctpp2->load_bytecode($template);
    } else {
#        Dancer::Logger->debug("Plain: ".$template);
   	 $b = $_ctpp2->parse_template($template);
    }

    $_ctpp2->param($tokens);
    return $_ctpp2->output($b);
}

1;
__END__

=pod

=head1 NAME

Dancer::Template::Ctpp2 - HTML::CTPP2 wrapper for Dancer

=head1 DESCRIPTION

This class is an interface between Dancer's template engine abstraction layer
and the L<HTML::CTPP2> module.

This template engine is much (22 -25 times) faster than others and contains extra functionality.

In order to use this engine, use the template setting:

    template: ctpp2

This can be done in your config.yml file or directly in your app code with the
B<set> keyword.

Since HTML::CTPP2 uses different syntax to other template engines like
Template::Toolkit, for current Dancer versions the default layout main.tt will
need to be updated, changing the C<[% content %]> line to:

    <TMPL_var content>

Future versions of Dancer may ask you which template engine you wish to use, and
write the default layout appropriately.

Also, currently template filenames should end with .tt; again, future Dancer
versions may change this requirement.

By default, Dancer configures HTML::CTPP2 engine to parse templates from source code
instead of compiled templates. This can be changed 
within your config file - for example:

    template: ctpp2
    engines:
        ctpp2:
            compiled: 1
            source_charset: 'CP1251'
            destination_charset: 'utf-8'

Compiled template filenames should end with .ct2.

C<source_charset> and C<destination_charset> settings are used for on-the-fly 
charset converting of template output. These settings are optional.

=head1 SEE ALSO

L<Dancer>, L<HTML::CTPP2>


=head1 AUTHOR
 
Maxim Nikolenko, C<< <mephist@zenon.net> >>
 
=head1 SUPPORT

You cat find documentation for CTPP2 library at:

L<http://ctpp.havoc.ru/en/index.html> - in English
L<http://ctpp.havoc.ru/index.html> - in Russian

=head1 CONTRIBUTING
 
This module is developed on Github at:                                                          
 
L<http://github.com/mephist/Dancer-Template-CTPP>
 
Feel free to fork the repo and submit pull requests!

=head1 LICENSE

This module is free software and released under the same terms as CTPP2 
library itself.

  Copyright (c) 2006 - 2009 CTPP Team

  Redistribution and use in source and binary forms, with or without
  modification, are permitted provided that the following conditions
  are met:
  1. Redistributions of source code must retain the above copyright
     notice, this list of conditions and the following disclaimer.
  2. Redistributions in binary form must reproduce the above copyright
     notice, this list of conditions and the following disclaimer in the
     documentation and/or other materials provided with the distribution.
  4. Neither the name of the CTPP Team nor the names of its contributors
     may be used to endorse or promote products derived from this software
     without specific prior written permission.

  THIS SOFTWARE IS PROVIDED BY THE REGENTS AND CONTRIBUTORS ``AS IS'' AND
  ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
  IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
  ARE DISCLAIMED.  IN NO EVENT SHALL THE REGENTS OR CONTRIBUTORS BE LIABLE
  FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
  DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS
  OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
  HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
  LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
  OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF
  SUCH DAMAGE.

=cut

