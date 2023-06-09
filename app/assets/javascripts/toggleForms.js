// // Purpose: To toggle the forms on the new user page based on the role selected
// function toggleForms() {
//     const roleSelection = document.getElementById('formCategory');
//     const agentForm = document.getElementById('agentForm');
//     const coopForm = document.getElementById('coopForm');
//     const employeeForm = document.getElementById('employeeForm');

//     roleSelection.addEventListener('change', () => {
//         if (roleSelection.value === 'Agent') {
//             agentForm.style.display = 'block';
//             coopForm.style.display = 'none';
//             employeeForm.style.display = 'none';
//         } else if (roleSelection.value === 'Coop') {
//             agentForm.style.display = 'none';
//             coopForm.style.display = 'block';
//             employeeForm.style.display = 'none';
//         } else if (roleSelection.value === 'Employee') {
//             agentForm.style.display = 'none';
//             coopForm.style.display = 'none';
//             employeeForm.style.display = 'block';
//         }
//     });
// };

// Refactored code
// Purpose: To toggle the forms on the new user page based on the role selected
function toggleForms() {
    // Get the role selection element and form elements
    const roleSelection = document.getElementById('formCategory');
    const forms = {
        'Agent': document.getElementById('agentForm'),
        'Coop': document.getElementById('coopForm'),
        'Employee': document.getElementById('employeeForm')
    };

    // Add a change event listener to the role selection element
    roleSelection.addEventListener('change', () => {
        // Loop through the forms and set their display property based on the selected role
        for (const [role, form] of Object.entries(forms)) {
            if (role === roleSelection.value) {
                // Show the form if the role matches the selected role
                form.style.display = 'block';
            } else {
                // Hide the form if the role does not match the selected role
                form.style.display = 'none';
            }
        }
    });
}


