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
	<title>{$opt.app_name} - Manage Ranks</title>
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
			<div class="card mb-3">
				<div class="card-header"><h1>Ranks</h1></div>
				<div class="card-body">
					<div class="table-responsive">
						<table class="table table-bordered table-striped">
							<thead>
								<tr>
									<th>Title</th>
									<th>Rendered HTML</th>
									<th>Rank Order</th>
								</tr>
							</thead>
							<tbody>
								{foreach from=$ranks item=row}
									<tr>
										<td>{$row.title|escape:'htmlall'}</td>
										<td>{$row.rendered}</td>
										<td>{$row.rankorder}</td>
										<td>
											<a href="ranks.php?action=edit&ranking={$row.ranking}#rankform"><img class="theme-image" data-light-src="images/pencil-light.png" data-dark-src="images/pencil-dark.png" src="images/pencil-light.png" border="0" alt="Edit Rank" title="Edit Rank" /></a>
											<a href="ranks.php?action=delete&ranking={$row.ranking}"><img class="theme-image" data-light-src="images/bin-light.png" data-dark-src="images/bin-dark.png" src="images/bin-light.png" border="0" alt="Delete Rank" title="Delete Rank" /></a>
											<a href="ranks.php?action=promote&ranking={$row.ranking}&rankorder={$row.rankorder}"><img class="theme-image" data-light-src="images/arrow-up-light.png" data-dark-src="images/arrow-up-dark.png" src="images/arrow-up-light.png" border="0" alt="Promote" title="Promote" /></a>
											<a href="ranks.php?action=demote&ranking={$row.ranking}&rankorder={$row.rankorder}"><img class="theme-image" data-light-src="images/arrow-down-light.png" data-dark-src="images/arrow-down-dark.png" src="images/arrow-down-light.png" border="0" alt="Demote" title="Demote" /></a>
										</td>
									</tr>
								{/foreach}
							</tbody>
						</table>
					</div> <!-- card body -->
				</div> <!-- table-responsive -->
			</div> <!-- card -->
			<div class="row row-cols-1 row-cols-md-2 g4 d-flex d-flex justify-content-center">
				<div class="col mb-3">
					<div class="card h-100">
						<form name="theform" id="theform" method="get" action="ranks.php" class="well form-horizontal">
							<div class="card-header">{if $action == "edit" || $action == "update"}Edit Rank '{$title|escape:'htmlall'}'{else}Add Rank{/if}</div>
							<div class="card-body">
								{if $action == "edit" || (isset($haserror) && $action == "update")}
									<input type="hidden" name="ranking" value="{$ranking}">
									<input type="hidden" name="action" value="update">
								{elseif $action == "" || (isset($haserror) && $action == "insert")}
									<input type="hidden" name="action" value="insert">
								{/if}
								<div class="row row-cols-3 g-3 align-items-center">
									<div class="col-2">
										<label class="col-form-label" for="title">Title</label>
									</div>
									<div class="col-10">
										<input id="title" name="title" class="form-control{if isset($title_error)} is-invalid{/if}" type="text" value="{$title|escape:'htmlall'}" maxlength="255" required>
									</div> <!-- col -->
								</div> <!-- row -->
								<div class="row row-cols-3 g-3 align-items-center">
									<div class="col-2">
										<label class="col-form-label" for="rendered">HTML</label>
									</div>
									<div class="col-10">
										<textarea id="rendered" name="rendered" class="form-control{if isset($rendered_error)} is-invalid{/if}" rows="5" cols="100" required>{$rendered|escape:'htmlall'}</textarea>
									</div> <!-- col -->
								</div> <!-- row -->
							</div> <!-- card body -->
							<div class="card-footer">
								<button type="submit" class="btn btn-primary">{if $action == "" || $action == "insert"}Add{else}Update{/if}</button>
								<button type="button" class="btn" onClick="document.location.href='ranks.php';">Cancel</button>
							</div> <!-- card footer -->
						</form>
					</div> <!-- card -->
				</div> <!-- col -->
			</div> <!-- row -->
		</div> <!-- container -->
	</main>
	{include file='footer.tpl'}
	{if isset($title_error)} <script> $(document).ready(function() { $('#title').focus(); }); </script> {/if}
	{if isset($rendered_error)} <script> $(document).ready(function() { $('#rendered').focus(); }); </script> {/if}
	{if isset($action) && $action == "edit"} <script> $(document).ready(function() { $('html, body').animate({ scrollTop: $(document).height() }, 'fast'); }); </script> {/if}
</body>
</html>
