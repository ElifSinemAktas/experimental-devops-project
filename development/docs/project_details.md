
## Project Goal

| **Service**              | **Responsibilities**                                                                                               | **Database**               |
|---------------------------|-------------------------------------------------------------------------------------------------------------------|----------------------------|
| **Frontend Service**      | Handles user-facing interactions and routes requests to backend services.                                         | None                      |
| **Checkout Service**      | Orchestrates the checkout process, including cart retrieval, product validation, shipping, and payment.            | PostgreSQL           |
| **Cart Service**          | Manages shopping cart operations such as adding, removing, and updating items.                                    | Redis                     |
| **Product Service**       | Manages product details, availability, and pricing.                                                              | MongoDB                   |
| **Payment Service**       | Simulates payment processing, returning mock payment success or failure.                                           | None                      |
| **Recommendation Service**| Provides product recommendations based on user behavior or purchase history.                                      | Redis (or Precomputed Store) |
| **Email Service**         | Sends transactional emails, such as order confirmations and status updates.                                        | None                      |
| **User Service**          | Manages user profiles, authentication, and user data retrieval.                                                  | PostgreSQL                 |

### 1. Frontend Service
**Role:** Acts as the user interface and routes requests to backend services.

**Responsibilities:**
- Fetch product catalog (ProductCatalog Service).
- Retrieve cart details and interact with the cart (Cart Service).
- Initiate checkout (Checkout Service).

### 2. Checkout Service
**Role:** The orchestrator of the e-commerce workflow.

**Responsibilities:**

- Validates cart details with Cart Service.
- Fetches product information (e.g., price, stock) from ProductCatalog Service.
- Retrieves user details (e.g., email, address) from User Service.
- Interacts with Payment Service for payment processing.
- Stores order data in its own database.
- Triggers Email Service to send confirmation emails.

**Database:** PostgreSQL to store:
- Orders (order_id, user_id, status, total_amount, created_at).
- Order Items (order_id, product_id, quantity, price).

### 3. Cart Service
**Role:** Manages the user’s shopping cart.

**Responsibilities:**
- Add/remove/update items in the cart.
- Provide cart details to the Checkout Service.

**Database:** Redis for fast and efficient cart operations (key-value pairs).

**Example structure:**
- Key: cart:{user_id}
- Value: List of products (product_id, quantity).

### 4. Product Service
**Role:** Provides product details, pricing, and availability.

**Responsibilities:**
- Fetch product metadata for display and validation.
- Maintain product stock levels.

**Database:** MongoDB for flexible product schemas.

**Example schema:**
```json
{
  "product_id": "123",
  "name": "T-shirt",
  "price": 19.99,
  "stock": 50,
  "category": "Apparel"
}
```

### 5. Payment Service (Mocked)
**Role:** Simulates payment processing.

**Responsibilities:**
- Validate payment requests (mock behavior).
- Return a mock transaction status (success/failure).

**Database:** None (stateless).

**Example Workflow:**
- Input: Order details (user, amount, payment method).
- Output:
```json
{
  "transaction_id": "mock_txn_123",
  "status": "SUCCESS"
}
```

### 6. Recommendation Service
**Role:** Suggests related products to users.

**Responsibilities:**
- Fetch product recommendations based on user behavior or similar products.
- Precompute recommendations using simple collaborative filtering (optional).

**Database:** Redis or a file-based data store for precomputed recommendations.

### 7. Email Service
**Role:** Sends transactional emails.

**Responsibilities:**
- Order confirmation emails.
- Status update emails.

**Database:** None (stateless).

**Email Provider:** Use a mock implementation.

### 8. User Service
**Role:** Manages user profiles, authentication, and user data retrieval.

**Responsibilities:**
- Handle user registration, login, and authentication.
- Store user profile information (e.g., name, email, address).
- Provide user data to other services like Checkout and Order.

**Database:** PostgreSQL.

**Example schema:**
```json
{
  "user_id": "u123",
  "name": "John Doe",
  "email": "johndoe@example.com",
  "address": "123 Main Street"
}
```

## Technology Stack

**Communication:**
- gRPC

**Backend:**
- FastAPI (Python) for User/Cart/ProductCatalog/Recommendation services.
- Node.js for Checkout services.

**Frontend:**
- React.js

**Databases:**
- MySQL/PostgreSQL for orders and user data.
- MongoDB for products.
- Redis for carts and recommendations.

**Deployment:**
- Use your RKE2 Kubernetes cluster.
- Expose services via Kubernetes Services and Ingress.

**CI/CD Pipeline:**
- Automate deployments with GitLab CI/CD.
