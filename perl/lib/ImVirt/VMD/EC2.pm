# ImVirt - I'm virtualized?
#
# Authors:
#   Thomas Liske <liske@ibh.de>
#
# Copyright Holder:
#   2012 (C) IBH IT-Service GmbH [http://www.ibh.de/]
#
# License:
#   This program is free software; you can redistribute it and/or modify
#   it under the terms of the GNU General Public License as published by
#   the Free Software Foundation; either version 2 of the License, or
#   (at your option) any later version.
#
#   This program is distributed in the hope that it will be useful,
#   but WITHOUT ANY WARRANTY; without even the implied warranty of
#   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#   GNU General Public License for more details.
#
#   You should have received a copy of the GNU General Public License
#   along with this package; if not, write to the Free Software
#   Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301 USA
#

package ImVirt::VMD::EC2;

use strict;
use warnings;
use constant PRODUCT => '|Xen PV (Amazon EC2)';

use ImVirt;
use ImVirt::VMD::Xen;
use LWP::Simple qw($ua get);

ImVirt::register_vmd(__PACKAGE__);

sub detect($) {
    ImVirt::debug(__PACKAGE__, 'detect()');

    my $dref = shift;

    my %detected = (ImVirt::IMV_PHYSICAL => {KV_POINTS => IMV_PTS_MINOR});
    my %rtree;
    ImVirt::VMD::Xen::detect(\%detected);
    ImVirt::_rtree_vm(\%detected, \%rtree, 0);
    my @res = sort { $rtree{$b} > $rtree{$a} } keys %rtree;
    my $vm = shift @res;

    return unless($vm eq 'Xen PV');

    $ua->timeout(3);
    ImVirt::inc_pts($dref, IMV_PTS_MAJOR, IMV_VIRTUAL, PRODUCT) if(get('http://169.254.169.254/'));
}

sub pres() {
    my @prods = (
	    PRODUCT,
    );

    return @prods;
}

1;
