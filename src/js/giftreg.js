// based on http://alittlecode.com/files/jQuery-Validate-Demo/

function validate_highlight(label) {
	$(label).closest('.row').addClass('danger');
}

function validate_success(label) {
	$(label).addClass('valid').closest('.row').removeClass('danger');
}
