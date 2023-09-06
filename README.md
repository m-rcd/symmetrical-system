# Systemmetrical System 

Rails app which uses Starling API to provide customers with a rounding up feature.
For a customer, the transactions are rounded up to the nearest pound and this amount is then transfered to a new saving goal.


## Technologies

- Ruby on rails 
- RSpec
- HTTPparty
- Starling API


## Set up

- Clone the repository

  ```
  https://github.com/m-rcd/symmetrical-system.git
  ```

- Go to the repository `symmetrical-system`

  ```
  cd symmetrical-system 
  ```

- Install dependencies
 
  ```
  bundle install
  ```

- Add your access token in `env` file like so: 

  ```
  ACCESS_TOKEN=<access_token>
  ```

## Running the application


- Run the server

  ```
  rails s
  ```

- To get the round_up, run the following command in a different terminal:

  ```
  curl -X POST http://localhost:3000/round_up
  ```

  Response will look like: 

  ```JSON
  {'round_up_amount':'1351 pence (£13.51)'}
  ```

  Since there is only one account and the transactions are all recent, the `account_uid` and dates (`min_date` and `max_date`) have default values if not sent in the request. 

  The default value for `account_uid` comes from a call to Starling API.
  The default value for `min_date` and `max_date` set to `02/09/2023` and `09/09/2023` respectively.

  However, they can also be sent in the request like so: 
 
   ```
   curl -X POST http://localhost:3000/round_up -d 'account_uid=<account_uid>' -d 'min_date=<min_date>' -d 'max_date=<max_date>'
   ```

   `min_date` and `max_date` should be in the `dd/mm/year` format. 

   
- To transfer the money to saving goal, run the following command in the terminal:

  ```
  curl -X POST http://localhost:3000/transfer
  ```
  
  The response will look like:

  ```JSON
  {'round_up_amount':'1351 pence (£13.51)','transfer_uid':'bf0f9563-4d81-4dbd-9a68-8c7f126e207d'}
  ```
  
  Same as `round_up`, the `account_uid` and dates (`min_date` and `max_date`) have default values and can be sent in the request. 

   ```
   curl -X POST http://localhost:3000/transfer -d 'account_uid=<account_uid>' -d 'min_date=<min_date>' -d 'max_date=<max_date>'
   ```
  This will create a new saving goal and transfer the round up money to this new goal.

## Running specs

  ```
  rspec
  ```

## Design

![Design](design.png)

## Approach

- I started by implementing an interface for Starling API. One for each resource (`Accounts`, `Transactions` and `SavingGoal`).
- I then implemented classes that I will need to implement the feature:
   - `RoundUp` class which fetches the transactions for a week (either sent from request or with default values) using `Transactions` interface, selects the out transaction and rounds up the amount to the nearest pound.
   - `TransferMoneyToSavingGoal` creates a new saving goal and then transfers the  money to this new saving goal using the `SavingGoal` interface.
- I then created the routes `round_up` and`transfer` 


