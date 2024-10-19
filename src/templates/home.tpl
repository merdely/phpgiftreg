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
	<title>{$opt.app_name} - Home Page for {$fullname|escape:'htmlall'}</title>
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
		$(document).ready(function() {
			{if $opt.confirm_item_deletes}
				$('a[rel=confirmitemdelete]').click(function(event) {
					var desc = $(this).attr('data-content');
					if (!window.confirm('Are you sure you want to delete "' + desc + '"?')) {
						event.preventDefault();
					}
				});
			{/if}
			{if $opt.shop_requires_approval}
				$('a[rel=confirmunshop]').click(function(event) {
					var fn = $(this).attr('data-content');
					if (!window.confirm('Are you sure you no longer wish to shop for ' + fn + '?')) {
						event.preventDefault();
					}
				});
			{/if}
		});
	</script>

</head>
<body>
	{include file='navbar.tpl'}
	<main>
		<div class="container">
			{if isset($message)}
				<div class="alert alert-success" role="alert">
					{$message|escape:'htmlall'}
				</div> <!-- alert -->
			{/if}
			{if $opt.show_helptext}
				<div class="card text-bg-info mb-3">
					<div class="card-header">Help</div>
					<div class="card-body">
					<ul>
						<li>You can click the column headers to sort by that attribute.</li>
						<li>List each item seperately on your list - do not combine items. (i.e. list each book of a 4-part series separately.)</li>
						<li>Once you've bought or decided not to buy an item, remember to return to the recipient's gift lists and mark it accordingly.</li>
						<li>If someone purchases an item on your list, click <img src="images/return-light.png" /> to mark it as received.</li>
					</ul>
					</div> <!-- card body -->
				</div> <!-- card -->
			{/if}
			<div class="card mb-3">
				<div class="card-header"><h1>My Items</h1></div>
				<div class="card-body">
					<div class="table-responsive">
						<table class="table table-bordered table-striped">
							<thead>
								<tr>
									<th class="colheader"><a href="index.php?mysort=name{if $mysort == "name"}&sortdir={$sortdir == "DESC" ? "ASC" : "DESC"}{/if}">Name{if $mysort == "name"} <img class="theme-image" data-light-src="images/caret-{$sortdir == "DESC" ? "DESC" : "ASC"}-light.png" data-dark-src="images/caret-{$sortdir == "DESC" ? "DESC" : "ASC"}-dark.png" src="images/caret-{$sortdir == "DESC" ? "DESC" : "ASC"}-light.png" border="0" />{/if}</a></th>
									<th class="colheader"><a href="index.php?mysort=ranking{if $mysort == "ranking"}&sortdir={$sortdir == "DESC" ? "ASC" : "DESC"}{/if}">Ranking{if $mysort == "ranking"} <img class="theme-image" data-light-src="images/caret-{$sortdir == "DESC" ? "DESC" : "ASC"}-light.png" data-dark-src="images/caret-{$sortdir == "DESC" ? "DESC" : "ASC"}-dark.png" src="images/caret-{$sortdir == "DESC" ? "DESC" : "ASC"}-light.png" border="0" />{/if}</a></th>
									<th class="colheader"><a href="index.php?mysort=category{if $mysort == "category"}&sortdir={$sortdir == "DESC" ? "ASC" : "DESC"}{/if}">Category{if $mysort == "category"} <img class="theme-image" data-light-src="images/caret-{$sortdir == "DESC" ? "DESC" : "ASC"}-light.png" data-dark-src="images/caret-{$sortdir == "DESC" ? "DESC" : "ASC"}-dark.png" src="images/caret-{$sortdir == "DESC" ? "DESC" : "ASC"}-light.png" border="0" />{/if}</a></th>
									<th class="colheader"><a href="index.php?mysort=source{if $mysort == "source"}&sortdir={$sortdir == "DESC" ? "ASC" : "DESC"}{/if}">Store{if $mysort == "source"} <img class="theme-image" data-light-src="images/caret-{$sortdir == "DESC" ? "DESC" : "ASC"}-light.png" data-dark-src="images/caret-{$sortdir == "DESC" ? "DESC" : "ASC"}-dark.png" src="images/caret-{$sortdir == "DESC" ? "DESC" : "ASC"}-light.png" border="0" />{/if}</a></th>
									<th class="colheader"><a href="index.php?mysort=price{if $mysort == "price"}&sortdir={$sortdir == "DESC" ? "ASC" : "DESC"}{/if}">Price{if $mysort == "price"} <img class="theme-image" data-light-src="images/caret-{$sortdir == "DESC" ? "DESC" : "ASC"}-light.png" data-dark-src="images/caret-{$sortdir == "DESC" ? "DESC" : "ASC"}-dark.png" src="images/caret-{$sortdir == "DESC" ? "DESC" : "ASC"}-light.png" border="0" />{/if}</a></th>
									<th class="rcolheader">Actions</th>
								</tr>
							</thead>
							<tbody>
								{foreach from=$myitems item=row}
									<tr valign="top">
										<td>
											<form name="itemform" id="itemform_{$row.itemid}" method="POST" action="item.php" enctype="multipart/form-data" class="well form-horizontal">
												<div class="modal" tabindex="-1" id="editmodal_{$row.itemid}">
													<div class="modal-dialog modal-lg modal-dialog-centered">
														<div class="modal-content">
															<div class="modal-header">
																<h5 class="modal-title">Item Info: {$row.name|truncate:60}</h5>
																<button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
															</div> <!-- modal-header -->
															<div class="modal-body">
																	<input type="hidden" name="itemid" value="{$row.itemid}">
																	<input type="hidden" name="action" value="update">
																<div class="row row-cols-2 mb-2 g-3 align-items-center">
																	<div class="col-4">
																		<label class="col-form-label" for="description">Name</label>
																	</div>
																	<div class="col">
																		<input id="name" name="name" type="text" value="{$row.name|escape:'htmlall'}" class="form-control{if isset($name_error)} is-invalid{/if}" placeholder="Name" maxlength="100" required>
																	</div>
																</div>
																<div class="row row-cols-2 mb-2 g-3 align-items-center">
																	<div class="col-4">
																		<label class="col-form-label" for="description">Description</label>
																	</div>
																	<div class="col">
																		<textarea id="description" name="description" class="form-control{if isset($description_error)} is-invalid{/if}" rows="3" cols="40">{$row.description|escape:'htmlall'}</textarea>
																	</div>
																</div>
																<div class="row row-cols-2 mb-2 g-3 align-items-center">
																	<div class="col-4">
																		<label class="col-form-label" for="category">Category</label>
																	</div>
																	<div class="col">
																		<select id="category" name="category" class="form-select">
																			{foreach from=$categories item=catrow}
																				<option value="{$catrow.categoryid}" {if $catrow.categoryid == $row.catid}SELECTED{/if}>{$catrow.category|escape:'htmlall'}</option>
																			{/foreach}
																		</select>
																	</div>
																</div>
																<div class="row row-cols-2 mb-2 g-3 align-items-center">
																	<div class="col-4">
																		<label class="col-form-label" for="price">Price ({$opt.currency_symbol})</label>
																	</div>
																	<div class="col">
																		<input id="price" name="price" type="text" value="{$row.pricenum|escape:'htmlall'}" class="form-control{if isset($price_error)} is-invalid{/if}" placeholder="0.00">
																	</div>
																</div>
																<div class="row row-cols-2 mb-2 g-3 align-items-center">
																	<div class="col-4">
																		<label class="col-form-label" for="source">Store/Retailer</label>
																	</div>
																	<div class="col">
																		<input id="source" name="source" type="text" value="{$row.source|escape:'htmlall'}" class="form-control{if isset($source_error)} is-invalid{/if}" maxlength="255" placeholder="Source">
																	</div>
																</div>
																<div class="row row-cols-2 mb-2 g-3 align-items-center">
																	<div class="col-4">
																		<label class="col-form-label" for="ranking">Ranking</label>
																	</div>
																	<div class="col">
																		<select id="ranking" size="{count($ranks)}" name="ranking" multiple="multiple" class="form-select">
																			{foreach from=$ranks item=rankrow}
																				<option value="{$rankrow.ranking}" {if $rankrow.ranking == $row.rankid}SELECTED{/if}>{$rankrow.title}</option>
																			{/foreach}
																		</select>
																	</div>
																</div>
																{if $opt.allow_multiples}
																	<div class="row row-cols-2 mb-2 g-3 align-items-center">
																		<div class="col-4">
																			<label class="col-form-label" for="quantity">Quantity</label>
																		</div>
																		<div class="col">
																			<input id="quantity" name="quantity" type="text" value="{$row.quantity|escape:'htmlall'}" class="form-control{if isset($quantity_error)} is-invalid{/if}" maxlength="3">
																		</div>
																	</div>
																{else}
																	<input type="hidden" name="quantity" value="1">
																{/if}
																<div class="row row-cols-2 mb-2 g-3 align-items-center">
																	<div class="col-4">
																		<label class="col-form-label" for="url">URL</label>
																	</div>
																	<div class="col">
																		<input id="url" name="url" type="text" inputmode="url" autocapitalize="off" spellcheck="false" value="{$row.url|escape:'htmlall'}" class="form-control{if isset($url_error)} is-invalid{/if}" maxlength="255">
																	</div>
																</div>
																<div class="row row-cols-2 mb-2 g-3 align-items-center">
																	<div class="col-4">
																		<label class="control-label" for="image">Image</label>
																	</div>
																	{if $opt.allow_images}
																		<div class="col">
																			{if $row.image_filename == ''}
																				<input type="radio" name="image" value="none" CHECKED>
																				No image.<br />
																				<input type="radio" name="image" value="upload" id="ifnew">
																				Upload image:
																				<input type="file" id="imagefile" name="imagefile">
																			{else}
																				<input type="radio" name="image" value="remove">
																				Remove existing image.<br />
																				<input type="radio" name="image" value="keep" CHECKED>
																				Keep existing image.<br />
																				<input type="radio" name="image" value="replace" id="ifreplace">
																				Replace existing image:
																				<input type="file" id="imagefile" name="imagefile">
																			{/if}
																		</div>
																	</div>
																{/if}
																<div class="row row-cols-2 mb-2 g-3 align-items-center">
																	<div class="col-4">
																		<label class="col-form-label" for="comment">Comment</label>
																	</div>
																	<div class="col">
																		<textarea id="comment" name="comment" class="form-control{if isset($comment_error)} is-invalid{/if}" rows="2" cols="40">{$row.comment|escape:'htmlall'}</textarea>
																	</div> <!-- col -->
																</div> <!-- row -->
															</div> <!-- modal-body -->
															<div class="modal-footer">
																{if $row.url != ''}<a role="button" class="btn btn-secondary" href="{$row.url}" target="_blank" title="{$row.url}"><img alt="Visit URL" title="Visit URL" src="images/link-dark.png" border="0" /></a>{/if}
																{if isset($row.image_filename)}<a role="button" class="btn btn-secondary" href="{$opt.image_subdir}/{$row.image_filename}" title="{$row.name|escape:'htmlall'}" data-lightbox="image-1"><img alt="View Image" title="View Image" src="images/image-dark.png" border="0" /></a>{/if}
																<a role="button" class="btn btn-secondary" href="receive.php?itemid={$row.itemid}" ><img alt="Mark Item Received" src="images/return-dark.png" title="Mark Item Received" border="0" /></a>
																<a role="button" class="btn btn-danger" rel="confirmitemdelete" data-content="{$row.name|escape:'htmlall'}" href="item.php?action=delete&itemid={$row.itemid}"><img alt="Delete Item" title="Delete Item" src="images/bin-dark.png" border="0" /></a>
																<button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
																<button type="submit" class="btn btn-primary">Save</button>
															</div> <!-- modal-footer -->
														</div> <!-- modal-content -->
													</div> <!-- modal-dialog -->
												</div> <!-- modal -->
											</form>
											<a href="#" data-bs-toggle="modal" data-bs-target="#editmodal_{$row.itemid}">
												<span title="{$row.description|escape:'htmlall'}">{$row.name|truncate:50|escape:'htmlall'}</span>
											</a>
											<span title="{$row.description|escape:'htmlall'}">
										</td>
										<td nowrap class="text-center">{$row.rankid}</td>
										<td>{$row.category|default:"&nbsp;"}</td>
										<td>{$row.source|default:"&nbsp;"}</td>
										<td align="right">{$row.price}</td>
										<td align="right" nowrap>
											{if $row.url != ''}
												<a href="{$row.url}" target="_blank" title="{$row.url}"><img class="theme-image" data-light-src="images/link-light.png" data-dark-src="images/link-dark.png" src="images/link-light.png" border="0" alt="Link" /></a>&nbsp;
											{/if}
											{if $row.image_filename != '' && $opt.allow_images}
												<a href="{$opt.image_subdir}/{$row.image_filename}" title="{$row.name|escape:'htmlall'}" data-lightbox="image-1"><img class="theme-image" data-light-src="images/image-light.png" data-dark-src="images/image-dark.png" src="images/image-light.png" border="0" alt="Image" /></a>&nbsp;
											{/if}
											<a href="receive.php?itemid={$row.itemid}" class="text-decoration-none"><img alt="Mark Item Received" class="theme-image" data-light-src="images/return-light.png" data-dark-src="images/return-dark.png" src="images/return-light.png" border="0" title="Mark Item Received" /></a>&nbsp;
											<a href="#" data-bs-toggle="modal" data-bs-target="#editmodal_{$row.itemid}"><img alt="Edit Item" class="theme-image" data-light-src="images/pencil-light.png" data-dark-src="images/pencil-dark.png" src="images/pencil-light.png" border="0" title="Edit Item" /></a>&nbsp;
											<a rel="confirmitemdelete" data-content="{$row.name|escape:'htmlall'}" href="item.php?action=delete&itemid={$row.itemid}" class="text-decoration-none"><img alt="Delete Item" class="theme-image" data-light-src="images/bin-light.png" data-dark-src="images/bin-dark.png" src="images/bin-light.png" border="0" alt="Delete" title="Delete Item" /></a>
										</td>
									</tr>
								{/foreach}
							</tbody>
						</table>
					</div> <!-- table-responsive -->
					{if $myitems_count > $opt.items_per_page || $offset > 0}
						<nav aria-label="Page navigation">
							<ul class="pagination justify-content-center">
									<li class="page-item{if $offset + $opt.items_per_page < $myitems_count} disabled{/if}"><a class="page-link" href="index.php?offset={$offset - $opt.items_per_page}">&laquo;</a></li>
								{for $i=0 to $myitems_count step $opt.items_per_page}
									<li class="page-item{if $offset >= $i && $offset < $i + $opt.items_per_page} active{/if}"><a class="page-link" href="index.php?offset={$i}">{$i + $opt.items_per_page}</a></li>
								{/for}
									<li class="page-item{if $offset >= $opt.items_per_page} disabled{/if}"><a class="page-link" href="index.php?offset={$offset + $opt.items_per_page}">&raquo;</a></li>
							</ul>
						</nav> <!-- pagination -->
					{/if}
				</div> <!-- card-body -->
				<div class="card-footer text-body-secondary">
					<form name="itemform" id="additemform" method="POST" action="item.php" enctype="multipart/form-data" class="well form-horizontal">
						<div class="modal" tabindex="-1" id="addmodal">
							<div class="modal-dialog modal-lg modal-dialog-centered">
								<div class="modal-content">
									<div class="modal-header">
										<h5 class="modal-title">Add Item</h5>
										<button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
									</div> <!-- modal-header -->
									<div class="modal-body">
											<input type="hidden" name="action" value="insert">
										<div class="row row-cols-2 mb-2 g-3 align-items-center">
											<div class="col-4">
												<label class="col-form-label" for="description">Name</label>
											</div>
											<div class="col">
												<input id="name" name="name" type="text" value="" class="form-control{if isset($name_error)} is-invalid{/if}" placeholder="Name" maxlength="100" required>
											</div>
										</div>
										<div class="row row-cols-2 mb-2 g-3 align-items-center">
											<div class="col-4">
												<label class="col-form-label" for="description">Description</label>
											</div>
											<div class="col">
												<textarea id="description" name="description" class="form-control{if isset($description_error)} is-invalid{/if}" rows="2" cols="40"></textarea>
											</div>
										</div>
										<div class="row row-cols-2 mb-2 g-3 align-items-center">
											<div class="col-4">
												<label class="col-form-label" for="category">Category</label>
											</div>
											<div class="col">
												<select id="category" name="category" class="form-select">
													{foreach from=$categories item=catrow}
														<option value="{$catrow.categoryid}" {if $catrow.categoryid == $opt.default_category}SELECTED{/if}>{$catrow.category|escape:'htmlall'}</option>
													{/foreach}
												</select>
											</div>
										</div>
										<div class="row row-cols-2 mb-2 g-3 align-items-center">
											<div class="col-4">
												<label class="col-form-label" for="price">Price ({$opt.currency_symbol})</label>
											</div>
											<div class="col">
												<input id="price" name="price" type="text" value="" class="form-control{if isset($price_error)} is-invalid{/if}" placeholder="0.00">
											</div>
										</div>
										<div class="row row-cols-2 mb-2 g-3 align-items-center">
											<div class="col-4">
												<label class="col-form-label" for="source">Store/Retailer</label>
											</div>
											<div class="col">
												<input id="source" name="source" type="text" value="" class="form-control{if isset($source_error)} is-invalid{/if}" maxlength="255" placeholder="Source">
											</div>
										</div>
										<div class="row row-cols-2 mb-2 g-3 align-items-center">
											<div class="col-4">
												<label class="col-form-label" for="ranking">Ranking</label>
											</div>
											<div class="col">
												<select id="ranking" size="{count($ranks)}" name="ranking" multiple="multiple" class="form-select">
													{foreach from=$ranks item=rankrow}
														<option value="{$rankrow.ranking}" {if $rankrow.ranking == $opt.default_ranking}SELECTED{/if}>{$rankrow.title}</option>
													{/foreach}
												</select>
											</div>
										</div>
										{if $opt.allow_multiples}
											<div class="row row-cols-2 mb-2 g-3 align-items-center">
												<div class="col-4">
													<label class="col-form-label" for="quantity">Quantity</label>
												</div>
												<div class="col">
													<input id="quantity" name="quantity" type="text" value="" class="form-control{if isset($quantity_error)} is-invalid{/if}" maxlength="3">
												</div>
											</div>
										{else}
											<input type="hidden" name="quantity" value="1">
										{/if}
										<div class="row row-cols-2 mb-2 g-3 align-items-center">
											<div class="col-4">
												<label class="col-form-label" for="url">URL</label>
											</div>
											<div class="col">
												<input id="url" name="url" type="text" inputmode="url" autocapitalize="off" spellcheck="false" value="" class="form-control{if isset($url_error)} is-invalid{/if}" maxlength="255">
											</div>
										</div>
										<div class="row row-cols-2 mb-2 g-3 align-items-center">
											<div class="col-4">
												<label class="control-label" for="image">Image</label>
											</div>
											{if $opt.allow_images}
												<div class="col">
													<input type="radio" name="image" value="none" CHECKED>
													No image.<br />
													<input type="radio" name="image" value="upload" id="ifnew">
													Upload image:
													<input type="file" id="imagefile" name="imagefile">
												</div>
											</div>
										{/if}
										<div class="row row-cols-2 mb-2 g-3 align-items-center">
											<div class="col-4">
												<label class="col-form-label" for="comment">Comment</label>
											</div>
											<div class="col">
												<textarea id="comment" name="comment" class="form-control{if isset($comment_error)} is-invalid{/if}" rows="2" cols="40"></textarea>
											</div> <!-- col -->
										</div> <!-- row -->
									</div> <!-- modal-body -->
									<div class="modal-footer">
										<button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
										<button type="submit" class="btn btn-primary">Save</button>
									</div> <!-- modal-footer -->
								</div> <!-- modal-content -->
							</div> <!-- modal-dialog -->
						</div> <!-- modal -->
					</form>
					<a href="#" data-bs-toggle="modal" data-bs-target="#addmodal">Add a new item</a>
				</div> <!-- card-footer -->
			</div> <!-- card -->
			<div class="row row-cols-1 row-cols-md-2 g4">
				<div class="col mb-3">
					<div class="card h-100">
						<div class="card-header">People To Shop For</div>
						<div class="card-body">
							<div class="table-responsive">
								<table class="table table-bordered table-striped">
									<thead>
										<tr>
											<th class="colheader">Name</th>
											<th class="rcolheader">Last Updated</th>
											<th class="rcolheader"># Items</th>
											<th>&nbsp;</th>
										</tr>
									</thead>
									<tbody>
										{foreach from=$shoppees item=row}
											<tr>
												<td>
													<a href="shop.php?shopfor={$row.userid}">
														{if $row.comment != ''}
															<span title="{$row.comment|escape:'htmlall'}">
														{/if}
														{$row.fullname|escape:'htmlall'}
														{if $row.comment != ''}
															</span>
														{/if}
														</a>
												</td>
												<td align="right">{$row.list_stamp}</td>
												<td align="right">{$row.itemcount}</td>
												<td align="right" nowrap>
													{if $row.itemcount > 0}
														<a href="shop.php?shopfor={$row.userid}"><img alt="Shop for {$row.fullname|escape:'htmlall'}" class="theme-image" data-light-src="images/store-light.png" data-dark-src="images/store-dark.png" src="images/store-light.png" border="0" title="Shop for {$row.fullname|escape:'htmlall'}"></a>
													{/if}
													{if !$row.is_unsubscribed}
														<a href="index.php?action=unsubscribe&shoppee={$row.userid}"><img alt="Unsubscribe from {$row.fullname|escape:'htmlall'}'s updates" class="theme-image" data-light-src="images/delete-light.png" data-dark-src="images/delete-dark.png" src="images/delete-light.png" border="0" title="Unsubscribe from {$row.fullname|escape:'htmlall'}'s updates"></a>
													{else}
														<a href="index.php?action=subscribe&shoppee={$row.userid}"><img alt="Subscribe to {$row.fullname|escape:'htmlall'}'s updates" class="theme-image" data-light-src="images/podcast-light.png" data-dark-src="images/podcast-dark.png" src="images/podcast-light.png" border="0" title="Subscribe to {$row.fullname|escape:'htmlall'}'s updates"></a>
													{/if}
													<a rel="confirmunshop" data-content="{$row.fullname|escape:'htmlall'}" href="index.php?action=cancel&shopfor={$row.userid}"><img class="theme-image" data-light-src="images/bin-light.png" data-dark-src="images/bin-dark.png" src="images/bin-light.png" border="0" alt="Don't shop for {$row.fullname|escape:'htmlall'} anymore" title="Don't shop for {$row.fullname|escape:'htmlall'} anymore" /></a>
												</td>
											</tr>
										{/foreach}
									</tbody>
								</table>
							</div> <!-- table-responsive -->
						</div> <!-- card body -->
					</div> <!-- card -->
				</div> <!-- col -->
				<div class="col mb-3">
					<div class="card h-100">
						<div class="card-header">Available People To Shopping For</div>
						<div class="card-body">
							<div class="table-responsive">
								<table class="table table-bordered table-striped">
									<thead>
									<tr>
										<th class="colheader">Name</th>
										<th>&nbsp;</th>
									</tr>
									</thead>
									<tbody>
										{foreach from=$prospects item=row}
											<tr>
												<td>{$row.fullname|escape:'htmlall'}</td>
												<td align="right" nowrap>
													{if $row.pending}
														<a href="index.php?action=cancel&shopfor={$row.userid}"><img class="theme-image" data-light-src="images/delete-light.png" data-dark-src="images/delete-dark.png" src="images/delete-light.png" border="0" alt="Cancel" title="Cancel" /></a>
													{else}
														<a href="index.php?action=request&shopfor={$row.userid}">
															{if $opt.shop_requires_approval}
																<img class="theme-image" data-light-src="images/cloud-add-light.png" data-dark-src="images/cloud-add-dark.png" src="images/cloud-add-light.png" border="0" alt="Request" title="Request" />
															{else}
																<img class="theme-image" data-light-src="images/cloud-add-light.png" data-dark-src="images/cloud-add-dark.png" src="images/cloud-add-light.png" border="0" alt="Add" title="Add" />
															{/if}
														</a>
													{/if}
												</td>
											</tr>
										{/foreach}
									</tbody>
								</table>
							</div> <!-- table-responsive -->
						</div> <!-- card body -->
					</div> <!-- card -->
				</div> <!-- col -->
				<div class="col mb-3">
					<div class="card h-100">
						<div class="card-header">Messages</div>
						<div class="card-body">
							<div class="table-responsive">
								<table class="table table-bordered table-striped">
									<thead>
										<tr>
											<th class="colheader">Date</th>
											<th class="colheader">Sender</th>
											<th class="colheader">Message</th>
											<th>&nbsp;</th>
										</tr>
									</thead>
									<tbody>
										{foreach from=$messages item=row}
											<tr>
												<td>{$row.created}</td>
												<td>{$row.fullname|escape:'htmlall'}</td>
												<td>{$row.message|escape:'htmlall'}</td>
												<td align="right">
													<a href="index.php?action=ack&messageid={$row.messageid}"><img alt="Acknowledge" title="Acknowledge" class="theme-image" data-light-src="images/delete-light.png" data-dark-src="images/delete-dark.png" src="images/delete-light.png" border="0"></a>
												</td>
											</tr>
										{/foreach}
									</tbody>
								</table>
							</div> <!-- table-responsive -->
						</div> <!-- card body -->
						<div class="card-footer text-body-secondary"><a href="message.php">Send a message</a></div>
					</div> <!-- card -->
				</div> <!-- col -->
				<div class="col mb-3">
					<div class="card h-100">
						<div class="card-header">Upcoming events (within {$opt.event_threshold} days)</div>
						<div class="card-body">
							<div class="table-responsive">
								<table class="table table-bordered table-striped">
									<thead>
									<tr>
										<th class="colheader">Name</th>
										<th class="colheader">Event</th>
										<th class="colheader">Date</th>
										<th class="colheader">Days left</th>
									</tr>
									</thead>
									<tbody>
									{foreach from=$events item=row}
										<tr>
											<td>
												{if $row.fullname == ''}
													<i>System event</i>
												{else}
													{$row.fullname|escape:'htmlall'}
												{/if}
											</td>
											<td>{$row.eventname|escape:'htmlall'}</td>
											<td>{$row.date}</td>
											<td>
												{if $row.daysleft == 0}
													<b>Today</b>
												{else}
													{$row.daysleft}
												{/if}
											</td>
										</tr>
									{/foreach}
									</tbody>
								</table>
							</div> <!-- table-responsive -->
						</div> <!-- card body -->
					</div> <!-- card -->
				</div> <!-- col -->
				{if $opt.shop_requires_approval || ($isadmin && $opt.newuser_requires_approval)}
					{if $opt.shop_requires_approval}
						<div class="col mb-3">
							<div class="card h-100">
								<div class="card-header">People Who Want To Shop For Me</div>
								<div class="card-body">
									<div class="table-responsive">
										<table class="table table-bordered table-striped">
											<thead>
												<tr>
													<th class="colheader">Name</th>
													<th>&nbsp;</th>
												</tr>
											</thead>
											<tbody>
												{foreach from=$pending item=row}
													<tr>
														<td>{$row.fullname|escape:'htmlall'}</td>
														<td align="right">
															<a href="index.php?action=approve&shopper={$row.userid}">Approve</a>&nbsp;/
															<a href="index.php?action=decline&shopper={$row.userid}">Decline</a>
														</td>
													</tr>
												{/foreach}
											</tbody>
										</table>
									</div> <!-- table-responsive -->
								</div> <!-- card body -->
							</div> <!-- card -->
						</div> <!-- col -->
					{/if}
					{if $isadmin && $opt.newuser_requires_approval}
					<div class="col mb-3">
						<div class="card h-100">
							<div class="card-header">Users Waiting For Approval</div>
							<div class="card-body">
								<div class="table-responsive">
									<table class="table table-bordered table-striped">
										<thead>
											<tr>
												<th class="colheader">Name</th>
												<th class="colheader">Family</th>
												<th>&nbsp;</th>
											</tr>
										</thead>
										<tbody>
											{foreach from=$approval item=row}
												<tr>
													<td>{$row.fullname|escape:'htmlall'} &lt;<a href="mailto:{$row.email|escape:'htmlall'}">{$row.email|escape:'htmlall'}</a>&gt;</td>
													<td>{$row.familyname|escape:'htmlall'}</td>
													<td align="right">
														<a href="admin.php?action=approve&userid={$row.userid}&familyid={$row.initialfamilyid}">Approve</a>&nbsp;/
														<a href="admin.php?action=reject&userid={$row.userid}">Reject</a>
													</td>
												</tr>
											{/foreach}
										</tbody>
									</table>
								</div> <!-- table-responsive -->
							</div> <!-- card body -->
						</div> <!-- card -->
					</div> <!-- col -->
					{/if}
				{/if}
			</div> <!-- row -->
		</div> <!-- container -->
	</main>
	{include file='footer.tpl'}
</body>
</html>
