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
	<title>{$opt.app_name} - Manage Categories</title>
	<meta name="viewport" content="width=device-width, initial-scale=1.0">
	<link href="css/phpgiftreg.css" rel="stylesheet">
	<link href="https://cdn.jsdelivr.net/npm/bootstrap@5/dist/css/bootstrap.min.css" rel="stylesheet" crossorigin="anonymous">
	<link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1/font/bootstrap-icons.min.css" rel="stylesheet" crossorigin="anonymous">
	<script src="https://cdn.jsdelivr.net/npm/jquery@3/dist/jquery.min.js" crossorigin="anonymous"></script>
	<script src="https://cdn.jsdelivr.net/npm/bootstrap@5/dist/js/bootstrap.bundle.min.js" crossorigin="anonymous"></script>
	<script src="https://cdn.jsdelivr.net/npm/jquery-validation@1/dist/jquery.validate.min.js" crossorigin="anonymous"></script>
	<script src="js/themeswitcher.js"></script>
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
			{if isset($error_message)}
				<div class="alert alert-danger" role="alert">
					{$error_message|escape:'htmlall'}
				</div>
			{/if}
			{if $opt.show_helptext}
				<div class="card text-bg-info mb-3">
					<div class="card-header">Help</div>
					<div class="card-body">
						Here you can specify categories <strong>of your own</strong>, like &quot;Motorcycle stuff&quot; or &quot;Collectibles&quot;.  This will help you categorize your gifts.
						Warning: deleting a category will uncategorize all items that used that category.
					</div>
				</div>
			{/if}
			<div class="card mb-3">
				<div class="card-header"><h1>Categories</h1></div>
				<div class="card-body">
					<div class="table-responsive">
						<table class="table table-bordered table-striped">
							<thead>
								<tr>
									<th>Category</th>
									<th># Items</th>
									<th>&nbsp;</th>
								</tr>
							</thead>
							<tbody>
								{foreach from=$categories item=row}
									<tr>
										<td>{$row.category|escape:'htmlall'}</td>
										<td>{$row.itemsin}</td>
										<td>
											<a href="categories.php?action=edit&categoryid={$row.categoryid}#catform"><img class="theme-image" data-light-src="images/pencil-light.png" data-dark-src="images/pencil-dark.png" src="images/pencil-light.png" border="0" title="Edit Category" alt="Edit Category" /></a>
											<a href="categories.php?action=delete&categoryid={$row.categoryid}"><img class="theme-image" data-light-src="images/bin-light.png" data-dark-src="images/bin-dark.png" src="images/bin-light.png" border="0" title="Delete Category" alt="Delete Category" /></a>
										</td>
									</tr>
								{/foreach}
							</tbody>
						</table>
					</div> <!-- table-responsive -->
				</div> <!-- card body -->
			</div> <!-- card -->
			<div class="row row-cols-1 row-cols-md-2 g4 d-flex d-flex justify-content-center">
				<div class="col mb-3">
					<div class="card h-100">
						<form name="categoryform" id="categoryform" method="get" action="categories.php" class="well form-horizontal">
							<div class="card-header">{if $action == "edit" || $action == "update"}Edit Category '{$category|escape:'htmlall'}'{else}Add Category{/if}</div>
							<div class="card-body">
									{if isset($action)}
										{if $action == "edit" || (isset($haserror) && $action == "update")}
											<input type="hidden" name="categoryid" value="{$categoryid}">
											<input type="hidden" name="action" value="update">
										{elseif $action == "" || (isset($haserror) && $action == "insert")}
											<input type="hidden" name="action" value="insert">
										{/if}
									{/if}
									<div class="row row-cols-3 g-3 align-items-center">
										<div class="col-3">
											<label class="col-form-label" for="category">Category name</label>
										</div>
										<div class="col-8">
											<input id="category" name="category" type="text" class="form-control{if isset($category_error)} is-invalid{/if}" value="{$category|escape:'htmlall'}" maxlength="255" aria-describedby="category-helper" required>
										</div> <!-- col -->
									</div> <!-- row -->
							</div> <!-- card body -->
							<div class="card-footer">
								<button type="submit" class="btn btn-primary">{if $action == "" || $action == "insert"}Add{else}Update{/if}</button>
								<button type="button" class="btn" onClick="document.location.href='categories.php';">Cancel</button>
							</div> <!-- card footer -->
						</form>
					</div> <!-- card -->
				</div> <!-- col -->
			</div> <!-- row -->
		</div> <!-- container -->
	</main>
	{include file='footer.tpl'}
	{if isset($category_error)} <script> $(document).ready(function() { $('#category').focus(); }); </script> {/if}
	{if isset($action) && $action == "edit"} <script> $(document).ready(function() { $('html, body').animate({ scrollTop: $(document).height() }, 'fast'); }); </script> {/if}
</body>
</html>
