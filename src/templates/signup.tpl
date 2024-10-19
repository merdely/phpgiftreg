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
	<title>{$opt.app_name} - Sign Up</title>
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
			{if isset($error_message)}
				<div class="alert alert-danger" role="alert">
					{$error_message|escape:'htmlall'}
				</div>
			{/if}
			<div class="row justify-content-center">
				<div class="col-sm mt-3" style="max-width: 500px;">
					{if isset($action) && $action == "signup" && !isset($haserror)}
						<div class="card mb-3">
							<div class="card-header">Thank you for signing up.</div>
							<div class="card-body">
								{if $opt.newuser_requires_approval}
									<p>The administrators have been informed of your request and you will receive an e-mail once they've made a decision.</p>
								{else}
									<p>Shortly, you will receive an e-mail with your initial password.</p>
								{/if}
								<p>Once you've received your password, click <a href="login.php">here</a> to login.</p>
						</div> <!-- card body -->
					</div> <!-- card -->
					{else}
						<div class="card text-bg-info mb-3">
							<div class="card-header">Complete the form below and click Submit.</div>
							<div class="card-body">
								{if $opt.newuser_requires_approval}
									<p>The list administrators will be notified of your request by e-mail and will approve or decline your request.
		</p>
									<p>If the e-mail address you supply is valid, you will be notified once a decision is made.</p>
								{else}
									<p>If the e-mail address you supply is valid, you will shortly receive an e-mail with your initial password.</p>
								{/if}
							</div> <!-- card body -->
						</div> <!-- card-->
						<div class="card mb-3">
							<form name="signupform" id="signupform" method="post" action="signup.php" class="well form-horizontal">
								<div class="card-header">Sign Up for the Gift Registry</div>
								<div class="card-body">
									<input type="hidden" name="action" value="signup">
									<div class="row align-items-center mb-3">
										<div class="col-4">
											<label class="col-form-label" for="username">Username</label>
										</div>
										<div class="col">
											<input id="username" name="username" type="text" class="form-control{if isset($username_error)} is-invalid{/if}" autocapitalize="off" spellcheck="false" value="{$username|escape:'htmlall'}" placeholder="Username" required>
										</div>
									</div>
									<div class="row align-items-center mb-3">
										<div class="col-4">
											<label class="col-form-label" for="fullname">Full name</label>
										</div>
										<div class="col">
											<input id="fullname" name="fullname" type="text" class="form-control{if isset($fullname_error)} is-invalid{/if}" value="{$fullname|escape:'htmlall'}" placeholder="Full name" required>
										</div>
									</div>
									<div class="row align-items-center mb-3">
										<div class="col-4">
											<label class="col-form-label" for="email">E-mail address</label>
										</div>
										<div class="col">
											<input id="email" name="email" type="text" class="form-control{if isset($email_error)} is-invalid{/if}" inputmode="email" autocapitalize="off" spellcheck="false" value="{$email|escape:'htmlall'}" placeholder="you@somewhere.com" required>
										</div>
									</div>
									{if $familycount > 1 && $opt.newuser_default_family == 0}
										<div class="row align-items-center mb-3">
											<div class="col-4">
												<label class="col-form-label" for="familyid">Family</label>
											</div>
											<div class="col">
												<select name="familyid" class="form-select">
													<option value="">(select one)</option>
													{foreach from=$families item=row}
														<option value="{$row.familyid}">{$row.familyname|escape:'htmlall'}</option>
													{/foreach}
												</select>
											</div> <!-- col -->
										</div> <!-- row -->
									{else}
										<input type="hidden" name="familyid" value="{$familyid}">
									{/if}
								</div> <!-- card-body -->
								<div class="card-footer">
									<button type="submit" class="btn btn-primary">Submit</button>
									<button type="button" class="btn" onClick="document.location.href='login.php';">Cancel</button>
								</div> <!-- card-footer -->
							</form>
						</div> <!-- card -->
					{/if}
				</div> <!-- col -->
			</div> <!-- row -->
		</div> <!-- container -->
	</main>
	{include file='footer.tpl'}
</body>
</html>
