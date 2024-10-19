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
	<title>{$opt.app_name} - Compose a Message</title>
	<link href="https://cdn.jsdelivr.net/npm/bootstrap@5/dist/css/bootstrap.min.css" rel="stylesheet" crossorigin="anonymous">
	<link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1/font/bootstrap-icons.min.css" rel="stylesheet" crossorigin="anonymous">
	<script src="https://cdn.jsdelivr.net/npm/jquery@3/dist/jquery.min.js" crossorigin="anonymous"></script>
	<script src="https://cdn.jsdelivr.net/npm/bootstrap@5/dist/js/bootstrap.bundle.min.js" crossorigin="anonymous"></script>
	<script src="js/themeswitcher.js"></script>
</head>
<body>
	{include file='navbar.tpl' isadmin=$isadmin}
	<main>
		<div class="container">
			<div class="row row-cols-1 row-cols-md-2 g4 d-flex d-flex justify-content-center">
				<div class="col mb-3">
					<div class="card h-100">
						<form name="message" method="get" action="message.php" class="well form-horizontal">
							<div class="card-header"><h1>Send a Message</h1></div>
							<div class="card-body">
								<input type="hidden" name="action" value="send">
								<div class="row row-cols-2 g-3 mb-2 align-items-center">
									<div class="col-4">
										<label class="control-label" for="recipients[]">Recipients</label>
									</div>
									<div class="col">
										<select name="recipients[]" size="{$rcount}" MULTIPLE class="form-control" aria-describedby="help-block" required>
											{foreach from=$recipients item=row}
												<option value="{$row.userid}">{$row.fullname|escape:'htmlall'}</option>
											{/foreach}
										</select>
										<span id="help-block" class="form-text">(Hold CTRL while clicking to select multiple names.)</p>
									</div>
								</div>
								<div class="row row-cols-2 g-3 mb-2 align-items-center">
									<div class="col-4">
										<label class="col-form-label" for="msg">Message</label>
									</div>
									<div class="col">
										<textarea id="msg" name="msg" rows="5" cols="40" class="form-control" required></textarea>
									</div> <!-- col -->
								</div> <!-- row -->
							</div> <!-- card-body -->
							<div class="card-footer">
								<button type="submit" class="btn btn-primary">Send Message</button>
								<button type="button" class="btn" onClick="document.location.href='index.php';">Cancel</button>
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
