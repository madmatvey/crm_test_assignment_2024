import React, { useEffect, useState } from "react";

// If I had more time, I would add the use of the state manager library here. 
// The author of the article on choosing a state manager 
// https://dev.to/nguyenhongphat0/react-state-management-in-2024-5e7l resonates with me.

export default () => {
  // List of fetched companies
  const [companies, setCompanies] = useState([]);

  // Table filters
  const [companyName, setCompanyName] = useState("");
  const [industry, setIndustry] = useState("");
  const [minEmployee, setMinEmployee] = useState("");
  const [minimumDealAmount, setMinimumDealAmount] = useState("");

  const [filtersChanged, setFiltersChanged] = useState(true);

  // Update filter state setters to also set filtersChanged to true
  const handleCompanyNameChange = (e) => {
    setCompanyName(e.target.value);
    setFiltersChanged(true);
  };
  
  const handleIndustryChange = (e) => {
    setIndustry(e.target.value);
    setFiltersChanged(true);
  };

  const handleMinEmployeeChange = (e) => {
    setMinEmployee(e.target.value);
    setFiltersChanged(true);
  };

  const handleMinimumDealAmountChange = (e) => {
    setMinimumDealAmount(e.target.value);
    setFiltersChanged(true);
  };

  const setCompanyListFromAPI = (url) => {
    fetch(url)
      .then((res) => {
        if (!res.ok) {
          throw new Error('Network response was not ok');
        }
        return res.json();
      })
      .then((res) => setCompanies(res))
      .catch((error) => {
        console.error('Error fetching data:', error);
        // Handle error, e.g., show a message to the user
      });
  };

  // Fetch companies from API
  useEffect(() => {
    if (filtersChanged) {
      const url = `/api/v1/companies?name=${companyName}&industry=${industry}&min_employee=${minEmployee}&minimum_deal_amount=${minimumDealAmount}`;
      setCompanyListFromAPI(url);
      setFiltersChanged(false);
    };
  }, [filtersChanged, companyName, industry, minEmployee, minimumDealAmount]);

  return (
    <div className="vw-100 primary-color d-flex align-items-center justify-content-center">
      <div className="jumbotron jumbotron-fluid bg-transparent">
        <div className="container secondary-color">
          <h1 className="display-4">Companies</h1>

          <label htmlFor="company-name">Company Name</label>
          <div className="input-group mb-3">
            <input type="text" className="form-control" id="company-name" value={companyName} onChange={e => handleCompanyNameChange(e)} />
          </div>

          <label htmlFor="industry">Industry</label>
          <div className="input-group mb-3">
            <input type="text" className="form-control" id="industry" value={industry} onChange={e => handleIndustryChange(e)} />
          </div>

          <label htmlFor="min-employee">Minimum Employee Count</label>
          <div className="input-group mb-3">
            <input type="text" className="form-control" id="min-employee" value={minEmployee} onChange={e => handleMinEmployeeChange(e)} />
          </div>

          <label htmlFor="min-amount">Minimum Deal Amount</label>
          <div className="input-group mb-3">
            <input type="text" className="form-control" id="min-amount" value={minimumDealAmount} onChange={e => handleMinimumDealAmountChange(e)} />
          </div>

          <table className="table">
            <thead>
              <tr>
                <th scope="col">Name</th>
                <th scope="col">Industry</th>
                <th scope="col">Employee Count</th>
                <th scope="col">Total Deal Amount</th>
              </tr>
            </thead>
            <tbody>
              {companies.map((company) => (
                <tr key={company.id}>
                  <td>{company.name}</td>
                  <td>{company.industry}</td>
                  <td>{company.employee_count}</td>
                  <td>{company.deals.reduce((sum, deal) => sum + deal.amount, 0)}</td>
                </tr>
              ))}
            </tbody>
          </table>
        </div>
      </div>
    </div>
  )
};
