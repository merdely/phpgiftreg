{*
This program is free software; you can redistribute it and/or modify
t under the terms of the GNU General Public License as published by
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
	<title>{$opt.app_name} - Login</title>
	<meta name="viewport" content="width=device-width, initial-scale=1.0">
	<link href="css/phpgiftreg.css" rel="stylesheet">
	<link href="https://cdn.jsdelivr.net/npm/bootstrap@5/dist/css/bootstrap.min.css" rel="stylesheet" crossorigin="anonymous">
	<link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1/font/bootstrap-icons.min.css" rel="stylesheet" crossorigin="anonymous">
	<script src="https://cdn.jsdelivr.net/npm/jquery@3/dist/jquery.min.js" crossorigin="anonymous"></script>
	<script src="https://cdn.jsdelivr.net/npm/bootstrap@5/dist/js/bootstrap.bundle.min.js" crossorigin="anonymous"></script>
	<script src="https://cdn.jsdelivr.net/npm/jquery-validation@1/dist/jquery.validate.min.js" crossorigin="anonymous"></script>
<!--
{if $reset_theme == "true"}
	<script>localStorage.setItem('theme', 'auto')</script>
{/if}
-->
	<script src="js/themeswitcher.js"></script>
</head>
<body>
	<main>
		<div class="container">
			<div class="row justify-content-center">
				<div class="col-sm" style="max-width: 500px;">
					<div class="card mt-3">
						<form name="loginform" id="loginform" method="post" action="login.php{if isset($from)}?from={$from}{if isset($querystring)}&querystring={$querystring}{/if}{/if}" class="well form-horizontal">
							<div class="card-header"><h1>Gift Registry</h1></div>
							<div class="card-body">
								{if isset($username)}
									<div class="alert alert-danger">Bad login.</div>
								{/if}
								<div class="row align-items-center mb-3">
									<div class="col-4">
										<label class="col-form-label" for="username">Username</label>
									</div>
									<div class="col">
										<input id="username" name="username" type="text" class="form-control" autocapitalize="off" spellcheck="false" placeholder="username" required />
									</div>
								</div>
								<div class="row align-items-center">
									<div class="col-4">
										<label class="col-form-label" for="password">Password</label>
									</div>
									<div class="col">
										<input id="password" name="password" type="password" class="form-control" autocapitalize="off" spellcheck="false" placeholder="password" required />
									</div> <!-- col -->
								</div> <!-- row -->
							</div> <!-- card body -->
							<div class="card-footer">
								<button type="submit" class="btn btn-primary">Login</button>
							</div> <!-- card footer -->
						</form>
					</div> <!-- card -->
					<div class="row row-cols-2 mt-2 g-3 align-items-center">
						<div class="col">
							<a href="signup.php">Need an account?</a>
						</div>
						<div class="col text-end">
							<a href="forgot.php">Forgot your password?</a>
						</div>
					</div>
				</div>
			</div>
		</div>
	</main>
	{include file='footer.tpl'}
</body>
</html>
