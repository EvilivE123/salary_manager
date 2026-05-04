document.addEventListener("turbo:load", () => {
  // Listen for clicks on the table body to utilize event delegation
  const tableBody = document.querySelector("#employees-table tbody");
  
  if (tableBody) {
    tableBody.addEventListener("click", (event) => {
      if (event.target.classList.contains("delete-employee-btn")) {
        const button = event.target;
        const employeeId = button.dataset.id;
        const row = document.getElementById(`employee_${employeeId}`);
        
        // Confirm before action
        if (confirm("Are you sure you want to delete this employee?")) {
          
          // Generate CSRF token for security
          const csrfToken = document.querySelector('meta[name="csrf-token"]').content;

          fetch(`/employees/${employeeId}`, {
            method: "DELETE",
            headers: {
              "X-CSRF-Token": csrfToken,
              "Accept": "application/json",
              "Content-Type": "application/json"
            }
          })
          .then(response => {
            if (response.ok) {
              // Smoothly remove the row from the DOM
              row.style.transition = "opacity 0.4s ease";
              row.style.opacity = 0;
              setTimeout(() => row.remove(), 400);
            } else {
              alert("Failed to delete the employee record.");
            }
          })
          .catch(error => {
            console.error("Error:", error);
            alert("An error occurred while communicating with the server.");
          });
        }
      }
    });
  }
});