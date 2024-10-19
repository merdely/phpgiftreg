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
{*
Inspired from https://getbootstrap.com/docs/4.0/components/navbar/#supported-content
*}

<nav class="navbar navbar-expand-lg bg-body-tertiary mb-4">
	<div class="container">
		<a class="navbar-brand" href="index.php"><img src="images/wishlist.png" height=25px width=25px /> {$opt.app_name}</a>
		<button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarSupportedContent" aria-controls="navbarSupportedContent" aria-expanded="false" aria-label="Toggle navigation">
			<span class="navbar-toggler-icon"></span>
		</button>
		<div class="collapse navbar-collapse" id="navbarSupportedContent">
			<ul class="navbar-nav me-auto mb-2 mb-lg-0">
				<li class="nav-item">
					<a class="nav-link" href="shoplist.php">My Shopping List</a>
				</li>
				<li class="nav-item">
					<a class="nav-link" href="mylist.php">My Items (printable)</a>
				</li>
				<li class="nav-item">
					<a class="nav-link" href="event.php">Manage Events</a>
				</li>
			</ul>
			<ul class="navbar-nav ms-auto mb-2 mb-lg-0">
				<li class="nav-item">
					<a class="nav-link" href="help.php">Help</a>
				</li>
				<li class="nav-item py-2 py-lg-1 col-12 col-lg-auto">
					<div class="vr d-none d-lg-flex h-100 mx-lg-2"></div>
					<hr class="d-lg-none my-2">
				</li>
				{if $isadmin}
					<li class="nav-item dropdown">
						<button class="btn btn-link nav-link py-2 px-0 px-lg-2 dropdown-toggle d-flex align-items-center"
							id="bd-admin"
							type="button"
							aria-expanded="false"
							data-bs-toggle="dropdown"
							data-bs-display="static"
							aria-label="Admin">
							<img width="20" height="20" class="theme-image mt-1 me-2" data-light-src="images/key-fill-light.png" data-dark-src="images/key-fill-dark.png" src="images/key-fill-light.png">
							<span class="d-lg-none ms-2" id="bd-admin-text">Admin</span>
						</button>
						<div class="dropdown-menu dropdown-menu-end" aria-labelledby="bd-admin">
							<a class="dropdown-item" href="users.php">Manage Users</a>
							<a class="dropdown-item" href="families.php">Manage Families</a>
							<a class="dropdown-item" href="categories.php">Manage Categories</a>
							<a class="dropdown-item" href="ranks.php">Manage Ranks</a>
						</div>
					</li>
				{/if}
				<li class="nav-item dropdown">
					<button class="btn btn-link nav-link py-2 px-0 px-lg-2 dropdown-toggle d-flex align-items-center"
						id="bd-theme"
						type="button"
						aria-expanded="false"
						data-bs-toggle="dropdown"
						data-bs-display="static"
						aria-label="Toggle theme (auto)">
						<img width="20" height="20" class="theme-image-active mt-1 me-2" data-light-light-src="images/sun-fill-light.png" data-dark-dark-src="images/moon-stars-fill-dark.png" data-auto-light-src="images/circle-half-light.png" data-auto-dark-src="images/circle-half-dark.png" src="images/circle-half-light.png">
						<span class="d-lg-none ms-2" id="bd-theme-text">Toggle theme</span>
					</button>
					<ul class="dropdown-menu dropdown-menu-end" aria-labelledby="bd-theme-text">
						<li>
							<button type="button" class="dropdown-item d-flex align-items-center active" data-bs-theme-value="auto" aria-pressed="true">
								<img width="20" height="20" class="theme-image mt-1 me-2" data-light-src="images/circle-half-light.png" data-dark-src="images/circle-half-dark.png" src="images/circle-half-light.png">
								Auto &nbsp;
								<img id="theme-auto" width="20" height="20" class="theme-image theme-image-check mt-1 me-2 d-none" data-light-src="images/check2-light.png" data-dark-src="images/check2-dark.png" src="images/check2-light.png">
							</button>
						</li>
						<li>
							<button type="button" class="dropdown-item d-flex align-items-center" data-bs-theme-value="light" aria-pressed="false">
								<img width="20" height="20" class="theme-image mt-1 me-2" data-light-src="images/sun-fill-light.png" data-dark-src="images/sun-fill-dark.png" src="images/sun-fill-light.png">
								Light &nbsp;
								<img id="theme-light" width="20" height="20" class="theme-image theme-image-check mt-1 me-2 d-none" data-light-src="images/check2-light.png" data-dark-src="images/check2-dark.png" src="images/check2-light.png">
							</button>
						</li>
						<li>
							<button type="button" class="dropdown-item d-flex align-items-center" data-bs-theme-value="dark" aria-pressed="false">
								<img width="20" height="20" class="theme-image mt-1 me-2" data-light-src="images/moon-stars-fill-light.png" data-dark-src="images/moon-stars-fill-dark.png" src="images/moon-stars-fill-light.png">
								Dark &nbsp;
								<img id="theme-dark" width="20" height="20" class="theme-image theme-image-check mt-1 me-2 d-none" data-light-src="images/check2-light.png" data-dark-src="images/check2-dark.png" src="images/check2-light.png">
							</button>
						</li>
					</ul>
				</li>
				<li class="nav-item dropdown">
					<button class="btn btn-link nav-link py-2 px-0 px-lg-2 dropdown-toggle d-flex align-items-center"
						id="bd-settings"
						type="button"
						aria-expanded="false"
						data-bs-toggle="dropdown"
						data-bs-display="static"
						aria-label="Profile Settings">
						<img width="20" height="20" class="theme-image mt-1 me-2" data-light-src="images/person-circle-light.png" data-dark-src="images/person-circle-dark.png" src="images/person-circle-light.png">
						<span class="d-lg-none ms-2" id="bd-settings-text">User Settings</span>
					</button>
					<div class="dropdown-menu dropdown-menu-end" aria-labelledby="bd-settings">
						<a class="dropdown-item" href="profile.php">Update Profile</a>
						<a class="dropdown-item" href="login.php?action=logout">Logout</a>
					</div>
				</li>
			</ul>
		</div>
	</div>
</nav>
