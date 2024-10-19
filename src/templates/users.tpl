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
	<title>{$opt.app_name} - Manage Users</title>
	<meta name="viewport" content="width=device-width, initial-scale=1.0">
	<link href="css/phpgiftreg.css" rel="stylesheet">
	<link href="https://cdn.jsdelivr.net/npm/bootstrap@5/dist/css/bootstrap.min.css" rel="stylesheet" crossorigin="anonymous">
	<link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1/font/bootstrap-icons.min.css" rel="stylesheet" crossorigin="anonymous">
	<script src="https://cdn.jsdelivr.net/npm/jquery@3/dist/jquery.min.js" crossorigin="anonymous"></script>
	<script src="https://cdn.jsdelivr.net/npm/bootstrap@5/dist/js/bootstrap.bundle.min.js" crossorigin="anonymous"></script>
	<script src="https://cdn.jsdelivr.net/npm/jquery-validation@1/dist/jquery.validate.min.js" crossorigin="anonymous"></script>
	<script src="js/themeswitcher.js"></script>
	<script language="JavaScript" type="text/javascript">
		$(document).ready(function() {
			$('a[rel=confirmdeleteuser]').click(function(event) {
				var u = $(this).attr('data-content');
				if (!window.confirm('Are you sure you want to delete ' + u + '?')) {
					event.preventDefault();
				}
			});
		});
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
			{if isset($error_message)}
				<div class="alert alert-danger" role="alert">
					{$error_message|escape:'htmlall'}
				</div>
			{/if}
			<div class="card mb-3">
				<div class="card-header"><h1>Users</h1></div>
				<div class="card-body">
					<div class="table-responsive">
						<table class="table table-bordered table-striped">
							<thead>
								<tr>
									<th>Username</th>
									<th>Fullname</th>
									<th>E-mail</th>
									<th>E-mail messages?</th>
									<th>Approved?</th>
									<th>Admin?</th>
									<th>&nbsp;</th>
								</tr>
							</thead>
							<tbody>
								{foreach from=$users item=row}
									<tr>
										<td>{$row.username}</td>
										<td>{$row.fullname}</td>
										<td>{$row.email}</td>
										<td>{if $row.email_msgs}Yes{else}No{/if}</td>
										<td>{if $row.approved}Yes{else}No{/if}</td>
										<td>{if $row.admin}Yes{else}No{/if}</td>
										<td align="right">
											<a href="users.php?action=edit&userid={$row.userid}#userform"><img alt="Edit User" class="theme-image" data-light-src="images/pencil-light.png" data-dark-src="images/pencil-dark.png" src="images/pencil-light.png" border="0" title="Edit User" /></a>
											<a rel="confirmdeleteuser" data-content="{$row.fullname|escape:'htmlall'}" href="users.php?action=delete&userid={$row.userid}"><img alt="Delete User" class="theme-image" data-light-src="images/bin-light.png" data-dark-src="images/bin-dark.png" src="images/bin-light.png" border="0" title="Delete User" /></a>
											{if $row.email != ''}
												<a href="users.php?action=reset&userid={$row.userid}&email={$row.email|escape:'htmlall'}"><img alt="Reset Password" class="theme-image" data-light-src="images/key-light.png" data-dark-src="images/key-dark.png" src="images/key-light.png" border="0" title="Reset Password" /></a>
											{else}
												Reset Pwd
											{/if}
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
						<div class="card-header">{if $action == "edit" || $action == "update"}Edit User{else}Add User{/if}</div>
						<div class="card-body">
							<form name="theform" id="theform" method="get" action="users.php" class="well form-horizontal">
								{if $action == "edit" || (isset($haserror) && $action == "update")}
									<input type="hidden" name="userid" value="{$edituserid}">
									<input type="hidden" name="action" value="update">
								{else if $action == "" || (isset($haserror) && $action == "insert")}
									<input type="hidden" name="action" value="insert">
								{/if}
								<div class="row row-cols-3 g-3 align-items-center">
									<div class="col-4">
										<label class="col-form-label" for="username">Username</label>
									</div>
									<div class="col">
										<input id="username" name="username" type="text" class="form-control{if isset($username_error)} is-invalid{/if}" autocapitalize="off" spellcheck="false" value="{$username|escape:'htmlall'}" maxlength="255" required>
									</div>
								</div>
								<div class="row row-cols-3 g-3 align-items-center">
									<div class="col-4">
										<label class="col-form-label" for="fullname">Full name</label>
									</div>
									<div class="col">
										<input id="fullname" name="fullname" type="text" class="form-control{if isset($fullname_error)} is-invalid{/if}" autocapitalize="off" spellcheck="false" value="{$fullname|escape:'htmlall'}" maxlength="255" aria-describedby="fullname-helper" required>
										{if isset($fullname_error)}
											<span id="fullname-helper" class="form-text">{$fullname_error|escape:'htmlall'}</span>
										{/if}
									</div>
								</div>
								<div class="row row-cols-3 g-3 align-items-center">
									<div class="col-4">
										<label class="col-form-label" for="email">E-mail address</label>
									</div>
									<div class="col">
										<input id="email" name="email" type="text" class="form-control{if isset($email_error)} is-invalid{/if}" inputmode="email" autocapitalize="off" spellcheck="false" value="{$email|escape:'htmlall'}" maxlength="255" required>
									</div>
								</div>
								<div class="row row-cols-2 g-2 align-items-center">
									<div class="col-4">
										<label class="col-form-label">Flags</label>
									</div>
									<div class="col">
										<input type="checkbox" name="email_msgs" {if $email_msgs}CHECKED{/if}>
										E-mail messages
										<br />
										<input type="checkbox" name="show_helptext" {if $show_helptext}CHECKED{/if}>
										Show Help Text
										<br />
										<input type="checkbox" name="approved" {if $approved}CHECKED{/if}>
										Approved
										<br />
										<input type="checkbox" name="admin" {if $userisadmin}CHECKED{/if}>
										Administrator
									</div> <!-- col -->
								</div> <!-- row -->
							</div> <!-- card-body -->
							<div class="card-footer">
								<button type="submit" class="btn btn-primary">{if $action == "" || $action == "insert"}Add{else}Update{/if}</button>
								<button type="button" class="btn" onClick="document.location.href='users.php';">Cancel</button>
							</div> <!-- card footer -->
						</form>
					</div> <!-- card -->
				</div> <!-- col -->
			</div> <!-- row -->
		</div> <!-- container -->
	</main>
	{include file='footer.tpl'}
	{if isset($username_error)} <script> $(document).ready(function() { $('#username').focus(); }); </script> {/if}
	{if isset($fullname_error)} <script> $(document).ready(function() { $('#fullname').focus(); }); </script> {/if}
	{if isset($email_error)} <script> $(document).ready(function() { $('#email').focus(); }); </script> {/if}
	{if isset($action) && $action == "edit"} <script> $(document).ready(function() { $('html, body').animate({ scrollTop: $(document).height() }, 'fast'); }); </script> {/if}
</body>
</html>
