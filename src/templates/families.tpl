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
	<title>{$opt.app_name} - Manage Families</title>
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
				<div class="alert alert-success" role="alert">{$message|escape:'htmlall'}</div>
			{/if}
			{if $opt.show_helptext}
				<div class="card text-bg-info mb-3">
					<div class="card-header">Help</div>
					<div class="card-body">
						Here you can specify families that will use your gift registry.  Members may belong to one or more family circles.
						After adding a new family, click Edit to add members to it.
					</div>
				</div>
			{/if}
			<div class="card mb-3">
				<div class="card-header"><h1>Families</h1></div>
				<div class="card-body">
					<div class="table-responsive">
						<table class="table table-bordered table-striped">
							<thead>
								<tr>
									<th>Family</th>
									<th># Members</th>
									<th>&nbsp;</th>
								</tr>
							</thead>
							<tbody>
								{foreach from=$families item=row}
									<tr>
										<td>{$row.familyname|escape:'htmlall'}</td>
										<td>{$row.members}</td>
										<td>
											<a href="families.php?action=edit&familyid={$row.familyid}#familyform"><img class="theme-image" data-light-src="images/pencil-light.png" data-dark-src="images/pencil-dark.png" src="images/pencil-light.png" alt="Edit Family" title="Edit Family" border="0" /></a>
											<a href="families.php?action=delete&familyid={$row.familyid}"><img class="theme-image" data-light-src="images/bin-light.png" data-dark-src="images/bin-dark.png" src="images/bin-light.png" alt="Delete Family" title="Delete Family" border="0" /></a>
										</td>
									</tr>
								{/foreach}
							</tbody>
						</table>
					</div> <!-- table-responsive -->
				</div> <!-- card-body -->
			</div> <!-- card -->
			<div class="row row-cols-1 row-cols-md-2 g4 d-flex d-flex justify-content-center">
				<div class="col mb-3">
					<div class="card h-100">
						<form name="theform" id="theform" method="get" action="families.php" class="well form-horizontal">
							<div class="card-header">{if $action == "edit" || $action == "update"}Edit family '{$familyname|escape:'htmlall'}'{else}Add Family{/if}</div>
							<div class="card-body">
								{if $action == "edit" || (isset($haserror) && $action == "update")}
									<input type="hidden" name="familyid" value="{$familyid}">
									<input type="hidden" name="action" value="update">
								{elseif $action == "" || (isset($haserror) && $action == "insert")}
									<input type="hidden" name="action" value="insert">
								{/if}
								<div class="row row-cols-3 g-3 align-items-center">
									<div class="col-3">
										<label class="col-form-label" for="familyname">Family name</label>
									</div>
									<div class="col">
										<input id="familyname" name="familyname" type="text" class="form-control{if isset($familyname_error)} is-invalid{/if}" value="{$familyname|escape:'htmlall'}" maxlength="255" aria-describedby="familyname-helper" required>
									</div> <!-- col -->
								</div> <!--row -->
							</div> <!-- card body -->
							<div class="card-footer">
								<button type="submit" class="btn btn-primary">{if $action == "" || $action == "insert" || $action == "update"}Add{else}Update{/if}</button>
								<button type="button" class="btn" onClick="document.location.href='families.php';">Cancel</button>
							</div> <!-- card footer -->
						</form>
					</div> <!-- card -->
				</div> <!-- col -->
			</div> <!-- row -->
			{if $action == "edit"}
				<div class="row row-cols-1 row-cols-md-2 g4 d-flex d-flex justify-content-center">
					<div class="col mb-3">
						<div class="card h-100">
							<form name="membership" method="get" action="families.php" class="well form-horizontal">
								<div class="card-header">Members of '{$familyname|escape:'htmlall'}'</div>
								<div class="card-body">
									<input type="hidden" name="familyid" value="{$familyid}">
									<input type="hidden" name="action" value="members">
									<div class="row row-cols-1 g-3 align-items-center">
										<div class="col">
											<select class="form-select mb-3" name="members[]" size="10" multiple aria-describedby="members-helper">
												{foreach from=$nonmembers item=row}
													<option value="{$row.userid}" {if $row.familyid != ''}SELECTED{/if}>{$row.fullname|escape:'htmlall'}</option>
												{/foreach}
											</select>
										</div>
										<div class="col text-center">
											<p id="members-helper" class="form-text">(Hold CTRL while clicking to select multiple users.)</p>
										</div> <!-- col -->
									</div> <!-- row -->
								</div> <!-- card-body -->
								<div class="card-footer">
									<button type="submit" class="btn btn-primary">Save</button>
									<button type="button" class="btn" onClick="document.location.href='families.php';">Cancel</button>
								</div> <!-- card footer -->
							</form>
						</div> <!-- card -->
					</div> <!-- col -->
				</div> <!-- row -->
			{/if}
		</div> <!-- container -->
	</main>
	{include file='footer.tpl'}
	{if isset($familyname_error)} <script> $(document).ready(function() { $('#familyname').focus(); }); </script> {/if}
	{if isset($action) && $action == "edit"} <script> $(document).ready(function() { $('html, body').animate({ scrollTop: $(document).height() }, 'fast'); }); </script> {/if}
</body>
</html>
