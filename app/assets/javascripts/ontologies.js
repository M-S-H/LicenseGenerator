$(document).ready(function() {

	var actions = 1;

	// New Ontology
	$("body").on("click", "#ontology-upload-button", function() {
		$("#ontology-upload").click();
	});

	$("body").on("change", "#ontology-upload", function() {
		var fn = $(this).val().replace("C:\\fakepath\\", "");
		$('#file-name').html(fn);
	})


	// New Action
	$("#new_action").click(function() {
		id = $(this).attr("ontology");
		var contents;

		$.ajax({
			type: "GET",
			url: "/new_action/" + id + "/" + actions,
			dataType: "html",
			success: function(data) {
				contents = data;
			},
			async: false
		});
		
		if (contents != "blank")
		{
			$("#action-container").append(contents);
		}

		actions += 1;

	});


	// Hide/Show Action
	$('body').on('click', '.fa-chevron-circle-up', function() {
		$(this).attr('class', 'fa fa-chevron-circle-down');
		action = "." + $(this).attr("action");
		$(action).hide();
	});

	$('body').on('click', '.fa-chevron-circle-down', function() {
		$(this).attr('class', 'fa fa-chevron-circle-up');
		action = "." + $(this).attr("action");
		$(action).show();
	});

});