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
	<title>{$opt.app_name} - My Shopping List</title>
	<meta name="viewport" content="width=device-width, initial-scale=1.0">
	<link href="css/phpgiftreg.css" rel="stylesheet">
	<link href="https://cdn.jsdelivr.net/npm/bootstrap@5/dist/css/bootstrap.min.css" rel="stylesheet" crossorigin="anonymous">
	<link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1/font/bootstrap-icons.min.css" rel="stylesheet" crossorigin="anonymous">
	<script src="https://cdn.jsdelivr.net/npm/jquery@3/dist/jquery.min.js" crossorigin="anonymous"></script>
	<script src="https://cdn.jsdelivr.net/npm/bootstrap@5/dist/js/bootstrap.bundle.min.js" crossorigin="anonymous"></script>
	<script src="js/themeswitcher.js"></script>
	<script language="JavaScript" type="text/javascript">
		function printPage() {
			window.print();
		}
	</script>
</head>
<body>
	{include file='navbar.tpl' isadmin=$isadmin}
	<main>
		<div class="container">
			<div class="row row-cols-1 row-cols-md-2 g-4">
				<div class="col">
					<div class="card h-100">
						<div class="card-header">Bookmarklet</div>
						<div class="card-body">
							<p>Drag the following bookmarklet to your browser's bookmark toolbar: <br />
							<a class="card-link btn btn-primary" href="javascript: (function () {
								var wishURL = window.location;
								var wishTitle = document.title;
								var appURL = '{$myurl}/item.php';
								appURL += '?action=insert&url=' + encodeURIComponent(wishURL);
								appURL += '&name=' + encodeURIComponent(wishTitle);
								if (window.location.href.includes('www.amazon.com')) {
									if (document.getElementById('landingImage')) {
										var imageSrc = document.getElementById('landingImage').src;
										appURL += '&image_url=' + encodeURIComponent(imageSrc);
									}
									var container = document.querySelector('#corePriceDisplay_desktop_feature_div');
									if (container) {
										if (container.querySelector('.a-price-symbol')) {
											var pricesymbol = container.querySelector('.a-price-symbol').textContent;
											appURL += '&pricesymbol=' + encodeURIComponent(pricesymbol);
										}
										if (container.querySelector('.a-price-whole') && container.querySelector('.a-price-fraction')) {
											var price = container.querySelector('.a-price-whole').textContent + container.querySelector('.a-price-fraction').textContent;
											appURL += '&price=' + encodeURIComponent(price);
										}
									}
								}
								appURL += '&bookmarklet=1';
								window.open(appURL);
								})();
								">🎁 Add to Wishlist</a></p>
<!--
								<p>For Chrome on Android, right click the button above and choose "Copy link address". Then click the "3 dots" menu at the top/right and click the star icon. At the bottom of the screen will be a pop-up to edit the new bookmark. If you miss it, go to the "3 dots" menu and choose Bookmarks and look in "Mobile bookmarks". Replace the text of "URL" with the copied text from the button above. Change the name to "wl". Open a store link in your browser, click on the address area and replace the url with "wl".</p>
-->
						</div> <!-- card body -->
					</div> <!-- card -->
				</div> <!-- col -->
				<div class="col">
					<div class="card h-100">
						<div class="card-header">Gift Registry Help</div>
						<div class="card-body">
							<ul>
								<li>You can click the column headers to sort by that attribute.</li>
								<li>List each item seperately on your list - do not combine items. (i.e. list each book of a 4-part series separately.)</li>
								<li>Once you've bought or decided not to buy an item, remember to return to the recipient's gift lists and mark it accordingly.</li>
								<li>If someone purchases an item on your list, click <img class="theme-image" data-light-src="images/return-light.png" data-dark-src="images/return-dark.png" src="images/return-dark.png" /> to mark it as received.</li>
							</ul>
						</div> <!-- card body -->
					</div> <!-- card -->
				</div> <!-- col -->
				<div class="col">
					<div class="card h-100">
						<div class="card-header">My Shopping List Help</div>
						<div class="card-body">
							<p>This is a list of all items you have <strong>reserved</strong>.  Once you've bought or decided not to buy an item, remember to return to the recipient's gift lists and mark it accordingly.</p>
						</div> <!-- card body -->
					</div> <!-- card -->
				</div> <!-- col -->
				<div class="col">
					<div class="card h-100">
						<div class="card-header">My Items Help</div>
						<div class="card-body">
							<ul>
								<li>You can click the column headers to sort by that attribute.</li>
								<li>Once you've bought or decided not to buy an item, remember to return to the recipient's gift lists and mark it accordingly.</li>
								<li><strong>Please login to the Gift Registry site to get the most recent version of this list.</strong></li>
								<li>For better printing results, please change your print orientation to "Landscape" mode.</li>
							</ul>
						</div> <!-- card body -->
					</div> <!-- card -->
				</div> <!-- col -->
				<div class="col">
					<div class="card h-100">
						<div class="card-header">My Events Help</div>
						<div class="card-body">
							<p>Here you can specify events <strong>of your own</strong>, like your birthday or your anniversary.  When the event occurs within {$opt.event_threshold} days, an event reminder will appear in the display of everyone who shops for you.</p>
							{if $isadmin}
							<p><strong>System events</strong> are events which belong to no one -- like Christmas -- and will appear on everyone's display.</p>
							{/if}
							<p>Marking an item as <strong>Recurring yearly</strong> will cause them to show up year after year.</p>
						</div> <!-- card body -->
					</div> <!-- card -->
				</div> <!-- col -->
				<div class="col">
					<div class="card h-100">
						<div class="card-header">Website Help</div>
						<div class="card-body">
							<p>In addition to this help, you can also see help information on each page. This setting is available via Update Profile (menu at upper/right) or by checking the box below and clicking Save.</p>
							<div class="container mt-3 ms-3 me-3 mb-3">
								<form name="theform" id="theform" method="post" action="help.php" class="well form-horizontal">
									<input type="hidden" name="action" value="save" />
									<input type="checkbox" id="show_helptext" name="show_helptext" {if $show_helptext}CHECKED{/if}>
									Show help messages on pages <br /><br />
									<button type="submit" class="btn btn-primary">Update Profile</button>
								</form>
							</div>
						</div> <!-- card body -->
					</div> <!-- card -->
				</div> <!-- col -->
			</div> <!-- row -->
		</div> <!-- container -->
	</main>
	{include file='footer.tpl'}
</body>
</html>
