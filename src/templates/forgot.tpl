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
	<title>{$opt.app_name} - Forgot Password</title>
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
	<main>
		<div class="container">
			{if isset($action) && $action == "forgot" && $error == ""}
				<div class="alert alert-success" role="alert">
					<p>Shortly, you will receive an e-mail with your new password.</p>
					<p>Once you've received your password, click <a href="login.php">here</a> to login.</p>
				</div>
			{else}
			<div class="row justify-content-center">
				<div class="col-sm" style="max-width: 800px;">
					<div class="card text-bg-info mt-3">
						<div class="card-header">Help</div>
						<div class="card-body">
							Supply your username and click Submit.<br />
							Your password will be reset and the new password will be sent to the e-mail address you have associated with your account.
						</div>
					</div>
					<div class="card mt-3">
						<form name="forgotform" id="forgotform" method="post" action="forgot.php" class="well form-horizontal">
							<div class="card-header"><h1>Reset Your Password</h1></div>
							<div class="card-body">
								<input type="hidden" name="action" value="forgot">
								<div class="row row-cols-2 g-3 align-items-center">
									<div class="col-4">
										<label class="col-form-label" for="username">Username</label>
									</div>
									<div class="col">
										<input id="username" name="username" type="text" class="form-control" autocapitalize="off" spellcheck="false" value="{$username|escape:'htmlall'}" required>
									</div> <!-- col -->
								</div> <!-- row -->
							</div> <!-- card body -->
							<div class="card-footer">
								<button type="submit" class="btn btn-primary">Submit</button>
								<button type="button" class="btn" onClick="document.location.href='login.php';">Cancel</button>
							</div> <!-- card footer -->
						</form>
					</div> <!-- card -->
				</div> <!-- col -->
			</div> <!-- row -->
		{/if}
		</div> <!-- container -->
	</main>
	{include file='footer.tpl'}
</body>
</html>
