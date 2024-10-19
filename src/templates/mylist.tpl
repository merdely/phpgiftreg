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
	<title>{$opt.app_name} - My Items</title>
	<meta name="viewport" content="width=device-width, initial-scale=1.0">
	<link href="css/phpgiftreg.css" rel="stylesheet">
	<link href="https://cdn.jsdelivr.net/npm/bootstrap@5/dist/css/bootstrap.min.css" rel="stylesheet" crossorigin="anonymous">
	<link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1/font/bootstrap-icons.min.css" rel="stylesheet" crossorigin="anonymous">
	<script src="https://cdn.jsdelivr.net/npm/jquery@3/dist/jquery.min.js" crossorigin="anonymous"></script>
	<script src="https://cdn.jsdelivr.net/npm/bootstrap@5/dist/js/bootstrap.bundle.min.js" crossorigin="anonymous"></script>
	<script src="js/themeswitcher.js"></script>

	<script language="JavaScript">
		function printPage() {
			window.print();
		}
	</script>
</head>
<body>
	{include file='navbar.tpl' isadmin=$isadmin}
	<main>
		<div class="container">
			{if $opt.show_helptext}
				<div class="card text-bg-info mb-3">
					<div class="card-header">Help</div>
					<div class="card-body">
							<ul>
								<li>You can click the column headers to sort by that attribute.</li>
								<li>Once you've bought or decided not to buy an item, remember to return to the recipient's gift lists and mark it accordingly.</li>
								<li><strong>Please login to the Gift Registry site to get the most recent version of this list.</strong></li>
								<li>For better printing results, please change your print orientation to "Landscape" mode.</li>
							</ul>
					</div> <!-- card-body -->
				</div> <!-- card -->
			{/if}
			<div class="card mb-3">
				<div class="card-header"><h1>My Items</h1></div>
				<div class="card-body">
					<div class="table-responsive">
						<table class="table table-bordered table-striped">
							<thead>
								<tr>
								<th class="colheader"><a href="mylist.php?sort=name{if $sort == "name"}&sortdir={$sortdir == "DESC" ? "ASC" : "DESC"}{/if}">Name{if $sort == "name"} <img class="theme-image" data-light-src="images/caret-{$sortdir == "DESC" ? "DESC" : "ASC"}-light.png" data-dark-src="images/caret-{$sortdir == "DESC" ? "DESC" : "ASC"}-dark.png" src="images/caret-{$sortdir == "DESC" ? "DESC" : "ASC"}-light.png" border="0" />{/if}</a></th>
								<th class="colheader"><a href="mylist.php?sort=ranking{if $sort == "ranking"}&sortdir={$sortdir == "DESC" ? "ASC" : "DESC"}{/if}">Ranking{if $sort == "ranking"} <img class="theme-image" data-light-src="images/caret-{$sortdir == "DESC" ? "DESC" : "ASC"}-light.png" data-dark-src="images/caret-{$sortdir == "DESC" ? "DESC" : "ASC"}-dark.png" src="images/caret-{$sortdir == "DESC" ? "DESC" : "ASC"}-light.png" border="0" />{/if}</a></th>
								<th class="colheader"><a href="mylist.php?sort=source{if $sort == "source"}&sortdir={$sortdir == "DESC" ? "ASC" : "DESC"}{/if}">Store{if $sort == "source"} <img class="theme-image" data-light-src="images/caret-{$sortdir == "DESC" ? "DESC" : "ASC"}-light.png" data-dark-src="images/caret-{$sortdir == "DESC" ? "DESC" : "ASC"}-dark.png" src="images/caret-{$sortdir == "DESC" ? "DESC" : "ASC"}-light.png" border="0" />{/if}</a></th>
								<th class="colheader"><a href="mylist.php?sort=category{if $sort == "category"}&sortdir={$sortdir == "DESC" ? "ASC" : "DESC"}{/if}">Category{if $sort == "category"} <img class="theme-image" data-light-src="images/caret-{$sortdir == "DESC" ? "DESC" : "ASC"}-light.png" data-dark-src="images/caret-{$sortdir == "DESC" ? "DESC" : "ASC"}-dark.png" src="images/caret-{$sortdir == "DESC" ? "DESC" : "ASC"}-light.png" border="0" />{/if}</a></th>
								<th class="colheader"><a href="mylist.php?sort=price{if $sort == "price"}&sortdir={$sortdir == "DESC" ? "ASC" : "DESC"}{/if}">Price{if $sort == "price"} <img class="theme-image" data-light-src="images/caret-{$sortdir == "DESC" ? "DESC" : "ASC"}-light.png" data-dark-src="images/caret-{$sortdir == "DESC" ? "DESC" : "ASC"}-dark.png" src="images/caret-{$sortdir == "DESC" ? "DESC" : "ASC"}-light.png" border="0" />{/if}</a></th>
								</tr>
							</thead>
							<tbody>
								{foreach from=$shoplist item=row}
									<tr>
										<td>{$row.name|escape:'htmlall'}</td>
										<td>{$row.ranktitle}</td>
										<td>{$row.source|escape:'htmlall'}</td>
										<td>{$row.category|escape:'htmlall'}</td>
										<td>{$row.price}</td>
									</tr>
								{/foreach}
							</tbody>
						</table>
					</div> <!-- table-responsive -->
				</div> <!-- card body -->
				<div class="card-footer">{$itemcount} item(s), {$totalprice} total.</div>
			</div> <!-- card -->
			<div class="card mb-3">
				<div class="card-body">
						<a onClick="printPage()" href="#">Send to printer</a>
				</div>
			</div>
		</div>
	</main>
	{include file='footer.tpl'}
</body>
</html>
