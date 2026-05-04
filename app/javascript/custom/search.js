document.addEventListener("turbo:load", () => {
  const searchInput = document.getElementById("employee-search-input");
  const searchForm = document.getElementById("employee-search-form");
  const turboFrame = document.getElementById("employees_list"); // Targets the wrapper from Phase 4.1
  
  if (!searchInput) return;

  let debounceTimer;

  searchInput.addEventListener("input", function() {
    clearTimeout(debounceTimer);
    
    debounceTimer = setTimeout(() => {
      // Construct the URL with current parameters
      const url = new URL(searchForm.action);
      const params = new URLSearchParams(new FormData(searchForm));
      url.search = params.toString();

      // We utilize Turbo's built-in fetch mechanism by updating the frame's src attribute.
      // This seamlessly updates the DOM without requiring manual HTML injection.
      if (turboFrame) {
        turboFrame.src = url.toString();
      }
    }, 300); // 300ms debounce
  });
  
  // Prevent standard form submission to stop full page reload
  searchForm.addEventListener("submit", (e) => {
    e.preventDefault();
  });
});