document.addEventListener("turbo:load", () => {
  const filterSelects = document.querySelectorAll('.dashboard-filter');
  const resetBtn = document.getElementById('reset-filters');
  
  if (filterSelects.length === 0) return;

  const fetchDashboardData = () => {
    const country = document.getElementById('country').value;
    const department = document.getElementById('department').value;
    
    // Construct the URL with query parameters
    const url = new URL('/dashboard', window.location.origin);
    if (country) url.searchParams.append('country', country);
    if (department) url.searchParams.append('department', department);

    // Fetch JSON response
    fetch(url, { headers: { "Accept": "application/json" } })
      .then(response => response.json())
      .then(data => updateWidgets(data))
      .catch(error => console.error('Dashboard Fetch Error:', error));
  };

  const updateWidgets = (data) => {
    // Formatting Helpers
    const formatCurrency = (num) => Number(num).toLocaleString('en-US');
    
    // Update KPI Text Nodes
    document.getElementById('widget-total-headcount').innerText = data.total_headcount;
    document.getElementById('widget-active-employees').innerText = data.active_employees;
    document.getElementById('widget-avg-salary').innerText = formatCurrency(data.avg_salary);
    document.getElementById('widget-min-salary').innerText = formatCurrency(data.min_salary);
    document.getElementById('widget-max-salary').innerText = formatCurrency(data.max_salary);
    
    // Example: Update Country List Widget
    const countryList = document.getElementById('widget-salary-country');
    countryList.innerHTML = '';
    for (const [country, salary] of Object.entries(data.salary_by_country)) {
      countryList.innerHTML += `<li class="list-group-item d-flex justify-content-between">
        <span>${country}</span><strong>${formatCurrency(salary)}</strong>
      </li>`;
    }

    // Example: Update Job title List Widget
    const titleList = document.getElementById('widget-salary-job-title');
    titleList.innerHTML = '';
    for (const [title, salary] of Object.entries(data.salary_by_title)) {
      titleList.innerHTML += `<li class="list-group-item d-flex justify-content-between">
        <span>${title}</span><strong>${formatCurrency(salary)}</strong>
      </li>`;
    }

    // Example: Update Department List Widget
    const departmentList = document.getElementById('widget-headcount-by-department');
    departmentList.innerHTML = '';
    for (const [department, headcount] of Object.entries(data.headcount_by_dept)) {
      departmentList.innerHTML += `<li class="list-group-item d-flex justify-content-between">
        <span>${department}</span><strong>${formatCurrency(headcount)}</strong>
      </li>`;
    }  
    
    // Example: Update Recent Hires
    const recentHiresContainer = document.getElementById('widget-recent-hires');
    
    // Start building the HTML, ensuring we keep the title and add Bootstrap table classes
    let recentHiresHTML = `
      <h6 class="card-title">Recent Hires</h6>
      <div class="table-responsive">
        <table class="table table-sm table-hover mt-3 mb-0">
          <thead>
            <tr>
              <th>Name</th>
              <th>Role</th>
              <th>Date</th>
            </tr>
          </thead>
          <tbody>
    `;

    // Assuming the array is passed as data.recent_hires
    if (data.recent_hires && data.recent_hires.length > 0) {
      data.recent_hires.forEach(employee => {
        // Map the array indices based on the columns: [first_name, last_name, job_title, hire_date]
        const firstName = employee[0];
        const lastName = employee[1];
        const jobTitle = employee[2];
        const hireDate = employee[3];
        
        recentHiresHTML += `
            <tr>
              <td>${firstName} ${lastName}</td>
              <td class="text-muted">${jobTitle}</td>
              <td>${hireDate}</td>
            </tr>
        `;
      });
    } else {
      recentHiresHTML += `
            <tr>
              <td colspan="3" class="text-center text-muted py-3">No recent hires to display.</td>
            </tr>
      `;
    }

    recentHiresHTML += `
          </tbody>
        </table>
      </div>
    `;

    // Inject the generated HTML into the DOM
    recentHiresContainer.innerHTML = recentHiresHTML;
  };

  // Attach event listeners
  filterSelects.forEach(select => {
    select.addEventListener('change', fetchDashboardData);
  });

  if (resetBtn) {
    resetBtn.addEventListener('click', () => {
      filterSelects.forEach(s => s.value = '');
      fetchDashboardData();
    });
  }
  
  // Initial load fetch
  fetchDashboardData();
});