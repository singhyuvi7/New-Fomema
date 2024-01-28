// console.log('javascripts/internal/sessions.js loaded');
setLoginUsernameEmailPlaceholder($('#internal_user_login_type').val());

$('#internal_user_login_type').change(function() {
    type = $(this).val();
    setLoginUsernameEmailPlaceholder(type);
});

function setLoginUsernameEmailPlaceholder(type) {
	placeholder = type === 'Code' ? 'Username' : 'Email';
	$('#internal_user_login').attr('placeholder', placeholder);
}