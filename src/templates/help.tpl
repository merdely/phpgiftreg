{*
This program is free software; you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation; either version 2 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program; if not, write to the Free Software
Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
*}

<!DOCTYPE html>
<html lang="en">
<head>
	<title>Test Gift Registry - My Shopping List</title>
	<meta name="viewport" content="width=device-width, initial-scale=1.0">
	<link href="bootstrap/css/bootstrap.min.css" rel="stylesheet">
					 
	<script language="JavaScript" type="text/javascript">
		function printPage() {
			window.print();
		}
	</script>
</head>
<body>
	{include file='navbar.tpl' isadmin=$isadmin}

	<div class="container" style="padding-top: 60px;">
		<div class="row">
			<div class="span12">
				<div class="well">
					<h1>Bookmarklet</h1>
					<p>Drag the following bookmarklet to your browser's toolbar:</p>
					<a class="btn btn-primary" href="javascript: (function () {
var wishURL = window.location;
var wishTitle = document.title;
var appURL = 'https://wishlist.erdelynet.com/item.php';
appURL += '?action=insert&url=' + encodeURIComponent(wishURL);
appURL += '&name=' + encodeURIComponent(wishTitle);
if (window.location.href.includes('www.amazon.com')) {
  var imageSrc = document.getElementById('landingImage').src;
  appURL += '&image_url=' + encodeURIComponent(imageSrc);
}
appURL += '&bookmarklet=1';
window.open(appURL);
})();
">🎁 Add to Wishlist</a>
				</div>
			</div>
		</div>
		<div class="row">
			<div class="span12">
				<div class="well">
					<h1>Gift Registry Help</h1>
				<ul>
					<li>You can click the column headers to sort by that attribute.</li>
					<li>List each item seperately on your list - do not combine items. (i.e. list each book of a 4-part series separately.)</li>
					<li>Once you've bought or decided not to buy an item, remember to return to the recipient's gift lists and mark it accordingly.</li>
					<li>If someone purchases an item on your list, click <img src="images/return.png" /> to mark it as received.</li>
				</ul>
				</div>
			</div>
		</div>
		<div class="row">
			<div class="span12">
				<div class="well">
					<h1>My Shopping List Help</h1>
						<p>This is a list of all items you have <strong>reserved</strong>.  Once you've bought or decided not to buy an item, remember to return to the recipient's gift lists and mark it accordingly.</p>
				</div>
			</div>
		</div>
		<div class="row">
			<div class="span12">
				<div class="well">
					<h1>My Items Help</h1>
						<ul>
							<li>You can click the column headers to sort by that attribute.</li>
							<li>Once you've bought or decided not to buy an item, remember to return to the recipient's gift lists and mark it accordingly.</li>
							<li><strong>Please login to the Gift Registry site to get the most recent version of this list.</strong></li>
							<li>For better printing results, please change your print orientation to "Landscape" mode.</li>
						</ul>
				</div>
			</div>
		</div>
		<div class="row">
			<div class="span12">
				<div class="well">
					<h1>Manage Events Help</h1>
					</p>Here you can specify events <strong>of your own</strong>, like your birthday or your anniversary.  When the event occurs within {$opt.event_threshold} days, an event reminder will appear in the display of everyone who shops for you.</p>
					{if $isadmin}
						<p><strong>System events</strong> are events which belong to no one -- like Christmas -- and will appear on everyone's display.</p>
					{/if}
					<p>Marking an item as <strong>Recurring yearly</strong> will cause them to show up year after year.</p>
				</div>
			</div>
		</div>
<!--
		<div class="row">
			<div class="span12">
				<div class="well">
				</div>
			</div>
		</div>
-->
	</div>

	<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
	<script src="bootstrap/js/bootstrap.bundle.min.js"></script>
</body>
</html>
