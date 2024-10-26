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
	<title>{$opt.app_name} - Shopping List for {$ufullname}</title>
	<meta name="viewport" content="width=device-width, initial-scale=1.0">
	<link href="css/phpgiftreg.css" rel="stylesheet">
	<link href="https://cdn.jsdelivr.net/npm/bootstrap@5/dist/css/bootstrap.min.css" rel="stylesheet" crossorigin="anonymous">
	<link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1/font/bootstrap-icons.min.css" rel="stylesheet" crossorigin="anonymous">
	<link href="https://cdn.jsdelivr.net/npm/lightbox2@2/dist/css/lightbox.min.css" rel="stylesheet" crossorigin="anonymous">
	<script src="https://cdn.jsdelivr.net/npm/jquery@3/dist/jquery.min.js" crossorigin="anonymous"></script>
	<script src="https://cdn.jsdelivr.net/npm/bootstrap@5/dist/js/bootstrap.bundle.min.js" crossorigin="anonymous"></script>
	<script src="https://cdn.jsdelivr.net/npm/lightbox2@2/dist/js/lightbox.min.js" crossorigin="anonymous"></script>
	<script src="js/themeswitcher.js"></script>
	<script src="js/bs-components.js"></script>
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
			{if isset($message)}
				<div class="alert alert-success" role="alert">
					{$message|escape:'htmlall'}
				</div>
			{/if}
			{if $opt.show_helptext}
				<div class="card text-bg-info mb-3">
					<div class="card-header">Help</div>
					<div class="card-body">
						<ul>
							<li>If you intend to purchase a gift for this person, click the <img src="images/locked-light.png"> icon.  If you end up actually purchasing it, come back and click the <img src="images/credit-card-3-light.png"> icon.  If you change your mind and don't want to buy it, come back and click the <img src="images/unlocked-light.png"> icon.</li>
							<li>If you return something you've purchased, come back and click the <img src="images/return-light.png"> icon.  It will remain reserved for you.</li>
							<li>Just because an item has a URL listed doesn't mean you have to buy it from there (unless the comment says so).</li>
							<li>You can click the column headers to sort by that attribute.</li>
							<li>If you see something you'd like for yourself, click the <img src="images/split-2-light.png"> icon to copy it to your own list.</li>
						</ul>
					</div> <!-- card body -->
				</div> <!-- card -->
		{/if}
			<div class="card mb-3">
				<div class="card-header"><h1>Shopping List for {$ufullname|escape:'htmlall'}</h1></div>
				<div class="card-body">
					<div class="table-responsive">
						<table class="table table-bordered table-striped">
							<thead>
							<tr>
								<th class="colheader"><a href="shop.php?shopfor={$shopfor}&sort=name{if $sort == "name"}&sortdir={$sortdir == "DESC" ? "ASC" : "DESC"}{/if}">Name{if $sort == "name"} <img class="theme-image" data-light-src="images/caret-{$sortdir == "DESC" ? "DESC" : "ASC"}-light.png" data-dark-src="images/caret-{$sortdir == "DESC" ? "DESC" : "ASC"}-dark.png" src="images/caret-{$sortdir == "DESC" ? "DESC" : "ASC"}-light.png" border="0" />{/if}</a></th>
								<th class="colheader"><a href="shop.php?shopfor={$shopfor}&sort=ranking{if $sort == "ranking"}&sortdir={$sortdir == "DESC" ? "ASC" : "DESC"}{/if}">Ranking{if $sort == "ranking"} <img class="theme-image" data-light-src="images/caret-{$sortdir == "DESC" ? "DESC" : "ASC"}-light.png" data-dark-src="images/caret-{$sortdir == "DESC" ? "DESC" : "ASC"}-dark.png" src="images/caret-{$sortdir == "DESC" ? "DESC" : "ASC"}-light.png" border="0" />{/if}</a></th>
								<th class="colheader"><a href="shop.php?shopfor={$shopfor}&sort=quantity{if $sort == "quantity"}&sortdir={$sortdir == "DESC" ? "ASC" : "DESC"}{/if}">Quantity{if $sort == "quantity"} <img class="theme-image" data-light-src="images/caret-{$sortdir == "DESC" ? "DESC" : "ASC"}-light.png" data-dark-src="images/caret-{$sortdir == "DESC" ? "DESC" : "ASC"}-dark.png" src="images/caret-{$sortdir == "DESC" ? "DESC" : "ASC"}-light.png" border="0" />{/if}</a></th>
								<th class="colheader"><a href="shop.php?shopfor={$shopfor}&sort=category{if $sort == "category"}&sortdir={$sortdir == "DESC" ? "ASC" : "DESC"}{/if}">Category{if $sort == "category"} <img class="theme-image" data-light-src="images/caret-{$sortdir == "DESC" ? "DESC" : "ASC"}-light.png" data-dark-src="images/caret-{$sortdir == "DESC" ? "DESC" : "ASC"}-dark.png" src="images/caret-{$sortdir == "DESC" ? "DESC" : "ASC"}-light.png" border="0" />{/if}</a></th>
								<th class="colheader"><a href="shop.php?shopfor={$shopfor}&sort=source{if $sort == "source"}&sortdir={$sortdir == "DESC" ? "ASC" : "DESC"}{/if}">Store{if $sort == "source"} <img class="theme-image" data-light-src="images/caret-{$sortdir == "DESC" ? "DESC" : "ASC"}-light.png" data-dark-src="images/caret-{$sortdir == "DESC" ? "DESC" : "ASC"}-dark.png" src="images/caret-{$sortdir == "DESC" ? "DESC" : "ASC"}-light.png" border="0" />{/if}</a></th>
								<th class="colheader"><a href="shop.php?shopfor={$shopfor}&sort=price{if $sort == "price"}&sortdir={$sortdir == "DESC" ? "ASC" : "DESC"}{/if}">Price{if $sort == "price"} <img class="theme-image" data-light-src="images/caret-{$sortdir == "DESC" ? "DESC" : "ASC"}-light.png" data-dark-src="images/caret-{$sortdir == "DESC" ? "DESC" : "ASC"}-dark.png" src="images/caret-{$sortdir == "DESC" ? "DESC" : "ASC"}-light.png" border="0" />{/if}</a></th>
								<th class="colheader"><a href="shop.php?shopfor={$shopfor}&sort=status{if $sort == "status"}&sortdir={$sortdir == "DESC" ? "ASC" : "DESC"}{/if}">Status{if $sort == "status"} <img class="theme-image" data-light-src="images/caret-{$sortdir == "DESC" ? "DESC" : "ASC"}-light.png" data-dark-src="images/caret-{$sortdir == "DESC" ? "DESC" : "ASC"}-dark.png" src="images/caret-{$sortdir == "DESC" ? "DESC" : "ASC"}-light.png" border="0" />{/if}</a></th>
								<th>Actions</th>
							</tr>
							</thead>
							<tbody>
							{foreach from=$shoprows item=row}
								{if $row.quantity > 1}
									{if $row.avail > 0 || $row.ireserved > 0 || $row.ibought > 0}
										{if $row.ireserved > 0}
											{assign var="reservetext" value="Reserve Another"}
										{else}
											{assign var="reservetext" value="Reserve Item"}
										{/if}
										{if $row.ibought > 0}
											{assign var="purchasetext" value="Purchase Another"}
										{elseif $row.ireserved > 0}
											{assign var="purchasetext" value="Convert Reserve to Purchase"}
										{else}
											{assign var="purchasetext" value="Purchase Item"}
										{/if}
									{/if}
								{/if}
								<tr valign="top">
									<td>
										<div class="modal" tabindex="-1" id="modal_{$row.itemid}">
											<div class="modal-dialog modal-lg modal-dialog-centered">
												<div class="modal-content">
													<div class="modal-header">
														<h5 class="modal-title">Item Info: {$row.name|truncate:60}</h5>
														<button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
													</div> <!-- model-header -->
													<div class="modal-body">
														<div class="row row-cols-2 mb-2 g-3 align-items-center">
															<div class="col-4">
																<label class="col-form-label" for="description">Name</label>
															</div>
															<div class="col">
																{$row.name|escape:'htmlall'}
															</div>
														</div>
														<div class="row row-cols-2 mb-2 g-3 align-items-center">
															<div class="col-4">
																<label class="col-form-label" for="description">Description</label>
															</div>
															<div class="col">
																{$row.description|escape:'htmlall'}
															</div>
														</div>
														<div class="row row-cols-2 mb-2 g-3 align-items-center">
															<div class="col-4">
																<label class="col-form-label" for="category">Category</label>
															</div>
															<div class="col">
																{$row.category|escape:'htmlall'}
															</div>
														</div>
														<div class="row row-cols-2 mb-2 g-3 align-items-center">
															<div class="col-4">
																<label class="col-form-label" for="price">Price ({$opt.currency_symbol})</label>
															</div>
															<div class="col">
																{$row.price|default:'0.00'}
															</div>
														</div>
														<div class="row row-cols-2 mb-2 g-3 align-items-center">
															<div class="col-4">
																<label class="col-form-label" for="source">Store/Retailer</label>
															</div>
															<div class="col">
																{$row.source|escape:'htmlall'}
															</div>
														</div>
														<div class="row row-cols-2 mb-2 g-3 align-items-center">
															<div class="col-4">
																<label class="col-form-label" for="ranking">Ranking</label>
															</div>
															<div class="col">
																{$row.rank}
															</div>
														</div>
														<div class="row row-cols-2 mb-2 g-3 align-items-center">
															<div class="col-4">
																<label class="col-form-label" for="quantity">Quantity</label>
															</div>
															<div class="col">
																{$row.quantity|escape:'htmlall'}
															</div>
														</div>
														<div class="row row-cols-2 mb-2 g-3 align-items-center">
															<div class="col-4">
																<label class="col-form-label" for="comment">Comment</label>
															</div>
															<div class="col">
																{$row.comment|escape:'htmlall'}
															</div> <!-- col -->
														</div> <!-- row -->
													</div> <!-- modal-body -->
													<div class="modal-footer">
														{if $row.url != ''}<a role="button" class="btn btn-secondary" href="{$row.url|escape:'htmlall'}" target="_blank"><img alt="Visit URL" title="Visit URL" src="images/link-dark.png" border="0" /></a>{/if}
														{if isset($row.image_filename)}<a role="button" class="btn btn-secondary" href="{$opt.image_subdir}/{$row.image_filename}" title="{$row.name|escape:'htmlall'}" data-lightbox="image-1"><img alt="View Image" title="View Image" src="images/image-dark.png" border="0" /></a>{/if}
														{if $row.quantity > 1}
															{if $row.avail > 0}<a role="button" class="btn btn-secondary" href="shop.php?action=reserve&itemid={$row.itemid}&shopfor={$shopfor}"><img alt="{$reservetext|escape:'htmlall'}" title="{$reservetext|escape:'htmlall'}" src="images/locked-dark.png" border="0" /></a>{/if}
															{if $row.avail > 0 || $row.ireserved > 0}<a role="button" class="btn btn-secondary" href="shop.php?action=purchase&itemid={$row.itemid}&shopfor={$shopfor}"><img alt="{$purchasetext|escape:'htmlall'}" title="{$purchasetext|escape:'htmlall'}" src="images/credit-card-3-dark.png" border="0" /></a>{/if}
															{if $row.ireserved > 0}<a role="button" class="btn btn-secondary" href="shop.php?action=release&itemid={$row.itemid}&shopfor={$shopfor}"><img alt="Release Item" title="Release Item" src="images/unlocked-dark.png" border="0" /></a>{/if}
															{if $row.ibought > 0}<a role="button" class="btn btn-secondary" href="shop.php?action=return&itemid={$row.itemid}&shopfor={$shopfor}"><img alt="Return Item" title="Return Item" src="images/return-dark.png" border="0" /></a>{/if}
														{else}
															{if $row.rfullname == '' && $row.bfullname == ''}
																<a role="button" class="btn btn-secondary" href="shop.php?action=reserve&itemid={$row.itemid}&shopfor={$shopfor}"><img alt="Reserve Item" title="Reserve Item" src="images/locked-dark.png" border="0" /></a>
																<a role="button" class="btn btn-secondary" href="shop.php?action=purchase&itemid={$row.itemid}&shopfor={$shopfor}"><img alt="{$purchasetext|escape:'htmlall'}" title="{$purchasetext|escape:'htmlall'}" src="images/credit-card-3-dark.png" border="0" /></a>
															{elseif $row.rfullname != ''}
																{if $row.reservedid == $userid}
																<a role="button" class="btn btn-secondary" href="shop.php?action=release&itemid={$row.itemid}&shopfor={$shopfor}"><img alt="Release Item" title="Release Item" src="images/unlocked-dark.png" border="0" /></a>
																<a role="button" class="btn btn-secondary" href="shop.php?action=purchase&itemid={$row.itemid}&shopfor={$shopfor}"><img alt="{$purchasetext|escape:'htmlall'}" title="{$purchasetext|escape:'htmlall'}" src="images/credit-card-3-dark.png" border="0" /></a>
																{/if}
															{/if}
														{/if}
														<a role="button" class="btn btn-secondary" href="shop.php?action=copy&itemid={$row.itemid}&shopfor={$shopfor}"><img alt="I Want This Too" title="I Want This Too" src="images/split-2-dark.png" border="0" /></a>
														<button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
													</div> <!-- modal-footer -->
												</div> <!-- modal-content -->
											</div> <!-- modal-dialog -->
										</div> <!-- modal -->
										<a href="#" data-bs-toggle="modal" data-bs-target="#modal_{$row.itemid}">
											<span title="{$row.description|escape:'htmlall'}">{$row.name|truncate:50|escape:'htmlall'}</span>
										</a>
									</td>
									<td nowrap class="text-center">{$row.rankid}</td>
									<td nowrap class="text-center">{$row.quantity}</td>
									<td>{$row.category|default:"&nbsp;"}</td>
									<td>{$row.source|escape:'htmlall'}</td>
									<td align="right">{$row.price}</td>
									{if $row.quantity > 1}
										<td> <!-- status -->
											{foreach from=$row.allocs item=alloc}
												<b>{$alloc}</b><br />
											{/foreach}
											{$row.avail} remaining.<br />
										</td>
										<td nowrap align="right"> <!-- actions -->
											{if $row.url != ''}<a href="{$row.url|escape:'htmlall'}" target="_blank"><img class="theme-image" data-light-src="images/link-light.png" data-dark-src="images/link-dark.png" src="images/link-light.png" border="0" alt="Image" /></a>&nbsp;{/if}
											{if $row.image_filename != '' && $opt.allow_images}<a href="{$opt.image_subdir}/{$row.image_filename}" title="{$row.description|escape:'htmlall'}" data-lightbox="image-1"><img class="theme-image" data-light-src="images/image-light.png" data-dark-src="images/image-dark.png" src="images/image-light.png" border="0" alt="Image" /></a>&nbsp;{/if}
											{if $row.avail > 0 || $row.ireserved > 0 || $row.ibought > 0}
												{if $row.avail > 0}
													<a href="shop.php?action=reserve&itemid={$row.itemid}&shopfor={$shopfor}"><img alt="{$reservetext|escape:'htmlall'}" title="{$reservetext|escape:'htmlall'}" class="theme-image" data-light-src="images/locked-light.png" data-dark-src="images/locked-dark.png" src="images/locked-light.png" border="0" /></a>
												{/if}
												{if $row.avail > 0 || $row.ireserved > 0}
													<a href="shop.php?action=purchase&itemid={$row.itemid}&shopfor={$shopfor}"><img alt="{$purchasetext|escape:'htmlall'}" title="{$purchasetext|escape:'htmlall'}" class="theme-image" data-light-src="images/credit-card-3-light.png" data-dark-src="images/credit-card-3-dark.png" src="images/credit-card-3-light.png" border="0" /></a>
												{/if}
											{/if}
											{if $row.ireserved > 0}
												<a href="shop.php?action=release&itemid={$row.itemid}&shopfor={$shopfor}"><img alt="Release Item" title="Release Item" class="theme-image" data-light-src="images/unlocked-light.png" data-dark-src="images/unlocked-dark.png" src="images/unlocked-light.png" border="0" /></a>
											{/if}
											{if $row.ibought > 0}
												<a href="shop.php?action=return&itemid={$row.itemid}&shopfor={$shopfor}"><img alt="Return Item" title="Return Item" class="theme-image" data-light-src="images/return-light.png" data-dark-src="images/return-dark.png" src="images/return-light.png" border="0" /></a>
											{/if}
										{* </td> *}
									{else}
										{if $row.rfullname == '' && $row.bfullname == ''}
											<td> <!-- status -->
												<i>Available.</i>
											</td>
											<td nowrap align="right"> <!-- actions -->
												{if $row.url != ''}<a href="{$row.url|escape:'htmlall'}" target="_blank"><img class="theme-image" data-light-src="images/link-light.png" data-dark-src="images/link-dark.png" src="images/link-light.png" border="0" alt="Image" /></a>&nbsp;{/if}
												{if $row.image_filename != '' && $opt.allow_images}<a href="{$opt.image_subdir}/{$row.image_filename}" title="{$row.description|escape:'htmlall'}" data-lightbox="image-1"><img class="theme-image" data-light-src="images/image-light.png" data-dark-src="images/image-dark.png" src="images/image-light.png" border="0" alt="Image" /></a>&nbsp;{/if}
												<a href="shop.php?action=reserve&itemid={$row.itemid}&shopfor={$shopfor}"><img alt="Reserve Item" title="Reserve Item" class="theme-image" data-light-src="images/locked-light.png" data-dark-src="images/locked-dark.png" src="images/locked-light.png" border="0" /></a>&nbsp;<a href="shop.php?action=purchase&itemid={$row.itemid}&shopfor={$shopfor}"><img alt="Purchase Item" title="Purchase Item" class="theme-image" data-light-src="images/credit-card-3-light.png" data-dark-src="images/credit-card-3-dark.png" src="images/credit-card-3-light.png" border="0" /></a>
							{* </td> *}
											{* </td> *}
										{elseif $row.rfullname != ''}
											{if $row.reservedid == $userid}
												<td> <!-- status -->
													<i><b>Reserved by you.</b></i>
												</td>
												<td align="right"> <!-- actions -->
													{if $row.url != ''}<a href="{$row.url|escape:'htmlall'}" target="_blank"><img class="theme-image" data-light-src="images/link-light.png" data-dark-src="images/link-dark.png" src="images/link-light.png" border="0" alt="Image" /></a>&nbsp;{/if}
													{if $row.image_filename != '' && $opt.allow_images}<a href="{$opt.image_subdir}/{$row.image_filename}" title="{$row.description|escape:'htmlall'}" data-lightbox="image-1"><img class="theme-image" data-light-src="images/image-light.png" data-dark-src="images/image-dark.png" src="images/image-light.png" border="0" alt="Image" /></a>&nbsp;{/if}
													<a href="shop.php?action=release&itemid={$row.itemid}&shopfor={$shopfor}"><img alt="Release Item" title="Release Item" class="theme-image" data-light-src="images/unlocked-light.png" data-dark-src="images/unlocked-dark.png" src="images/unlocked-light.png" border="0" /></a>&nbsp;<a href="shop.php?action=purchase&itemid={$row.itemid}&shopfor={$shopfor}"><img alt="Purchase Item" title="Purchase Item" class="theme-image" data-light-src="images/credit-card-3-light.png" data-dark-src="images/credit-card-3-dark.png" src="images/credit-card-3-light.png" border="0" /></a>
												{* </td> *}
											{else}
												<td> <!-- status -->
													{if $opt.anonymous_purchasing}
														<i>Reserved.</i>
													{else}
														<i>Reserved by {$row.rfullname|escape:'htmlall'}.</i>
													{/if}
												</td>
												<td> <!-- actions -->
												{* </td> *}
											{/if}
										{elseif $row.bfullname != ''}
											{if $row.boughtid == $userid}
												<td> <!-- status -->
													<i><b>Bought by you.</b></i>
												</td>
												<td align="right"> <!-- actions -->
													{if $row.url != ''}<a href="{$row.url|escape:'htmlall'}" target="_blank"><img class="theme-image" data-light-src="images/link-light.png" data-dark-src="images/link-dark.png" src="images/link-light.png" border="0" alt="Image" /></a>&nbsp;{/if}
													{if $row.image_filename != '' && $opt.allow_images}<a href="{$opt.image_subdir}/{$row.image_filename}" title="{$row.description|escape:'htmlall'}" data-lightbox="image-1"><img class="theme-image" data-light-src="images/image-light.png" data-dark-src="images/image-dark.png" src="images/image-light.png" border="0" alt="Image" /></a>&nbsp;{/if}
													<a href="shop.php?action=return&itemid={$row.itemid}&shopfor={$shopfor}"><img alt="Return Item" title="Return Item" class="theme-image" data-light-src="images/return-light.png" data-dark-src="images/return-dark.png" src="images/return-light.png" border="0" /></a>
												{* </td> *}
											{else}
												{if $opt.anonymous_purchasing}
													<td> <!-- status -->
														<i>Bought.</i>
													</td>
													<td> <!-- actions -->
													{* </td> *}
												{else}
													<td> <!-- status -->
														<i>Bought by {$row.bfullname|escape:'htmlall'}.</i>
													</td>
													<td> <!-- actions -->
													{* </td> *}
												{/if}
											{/if}
										{/if}
									{/if}
									{* <td> *}
										<a href="shop.php?action=copy&itemid={$row.itemid}&shopfor={$shopfor}"><img alt="I Want This Too" title="I Want This Too" class="theme-image" data-light-src="images/split-2-light.png" data-dark-src="images/split-2-dark.png" src="images/split-2-light.png" border="0" /></a>
									</td>
								</tr>
							{/foreach}
							</tbody>
						</table>
					</div> <!-- table-responsive -->
				</div> <!-- card body -->
				<div class="card-footer text-body-secondary"><a onClick="printPage()" href="#">Send to printer</a></div>
			</div> <!-- card -->
			<div class="row row-cols-1 row-cols-md-2 g4 d-flex d-flex justify-content-center">
				<div class="col mb-3">
					<div class="card mb-3">
						<div class="card-header"><h1>{$ufullname|escape:'htmlall'} Info</h1></div>
						<div class="card-body">
							{if $uemail != ''}
								Email Address: {$uemail|escape:'htmlall'}<br /><br />
							{/if}
							{if $ucomment != ''}
								{$ucomment|escape:'htmlall'|nl2br}
							{/if}
						</div> <!-- col -->
					</div> <!-- row -->
				</div> <!-- col -->
			</div> <!-- row -->
			<div class="card text-bg-info mb-3">
				<div class="card-header">Legend</div>
				<div class="card-body text-center">
					<img src="images/locked-light.png" alt="Reserve" title="Reserve"> = Reserve, <img src="images/unlocked-light.png" alt="Release" title="Release"> = Release, <img src="images/credit-card-3-light.png" alt="Purchase" title="Purchase"> = Purchase, <img src="images/return-light.png" alt="Return" title="Return"> = Return, <img src="images/split-2-light.png" alt="I Want This Too" title="I Want This Too"> = I Want This Too
				</div> <!-- card body -->
			</div> <!-- card -->
		</div>
	</main>
	{include file='footer.tpl'}

</body>
</html>
