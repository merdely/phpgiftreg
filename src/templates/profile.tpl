{*
This program is free software; you can redistribute it and/or modify
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
	<title>{$opt.app_name} - Update Profile</title>
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
			<div class="row row-cols-1 row-cols-md-2 g4 d-flex d-flex justify-content-center">
				<div class="col mb-3">
					<div class="card h-100">
						<form name="changepwdform" id="changepwdform" action="profile.php" method="POST" class="well form-horizontal">
							<div class="card-header">Change Password</div>
							<div class="card-body">
								<input type="hidden" name="action" value="changepwd">
								<div class="row row-cols-2 g-3 align-items-center">
									<div class="col-4">
										<label class="col-form-label" for="newpwd">New password</label>
									</div>
									<div class="col">
										<input type="password" id="newpwd" name="newpwd" class="form-control">
									</div>
									<div class="col-4">
										<label class="control-label" for="confpwd">Confirm password</label>
									</div>
									<div class="col">
										<input type="password" id="confpwd" name="confpwd" class="form-control">
									</div> <!-- col -->
								</div> <!-- row -->
							</div> <!-- card body -->
							<div class="card-footer">
								<button type="submit" class="btn btn-primary">Change Password</button>
								<button type="button" class="btn" onclick="document.location.href='index.php';">Cancel</button>
							</div> <!-- card footer -->
						</form>
					</div> <!-- card -->
				</div> <!-- col -->
			</div> <!-- row -->
			<div class="row row-cols-1 row-cols-md-2 g4 d-flex d-flex justify-content-center">
				<div class="col mb-3">
					<div class="card h-100">
						<form name="profileform" id="profileform" action="profile.php" method="POST" class="well form-horizontal">
							<div class="card-header">Update Profile</div>
							<div class="card-body">
								<input type="hidden" name="action" value="save">
								<div class="row row-cols-2 g-3 align-items-center">
									<div class="col-4">
										<label class="col-form-label" for="fullname">Full name</label>
									</div>
									<div class="col">
										<input type="text" id="fullname" name="fullname" class="form-control" value="{$fullname|escape:'htmlall'}" required>
									</div>
									<div class="col-4">
										<label class="col-form-label" for="email">E-mail address</label>
									</div>
									<div class="col">
										<input type="text" id="email" name="email" class="form-control" value="{$email|escape:'htmlall'}" required>
									</div>
									<div class="col-4">
										<label class="col-form-label" for="email_msgs">Copy on msg</label>
									</div>
									<div class="col">
										<input type="checkbox" id="email_msgs" name="email_msgs" {if $email_msgs}CHECKED{/if}>
										E-mail me a copy of every message
									</div> <!-- col -->
									<div class="col-4">
										<label class="control-label" for="show_helptext">Show help text</label>
									</div> <!-- col -->
									<div class="col">
										<input type="checkbox" id="show_helptext" name="show_helptext" {if $show_helptext}CHECKED{/if}>
										Show help messages on pages
									</div>
								</div>
								<div class="row row-cols-1 mt-2 align-items-center">
									<div class="col-auto">
										<label class="col-form-label" for="comment">Comments / shipping address / etc. (optional)</label>
									</div>
									<div class="col">
										<textarea id="comment" name="comment" rows="5" cols="40" class="form-control">{$comment|escape:'htmlall'}</textarea>
									</div> <!-- col -->
								</div> <!-- row -->
							</div> <!-- card-body -->
							<div class="card-footer">
								<button type="submit" class="btn btn-primary">Update Profile</button>
								<button type="button" class="btn" onclick="document.location.href='index.php';">Cancel</button>
							</div> <!-- card footer -->
						</form>
					</div> <!-- card -->
				</div> <!-- col -->
			</div> <!-- row -->
		</div> <!-- container -->
	</main>
	{include file='footer.tpl'}
</body>
</html>
