jest.mock("../src/models/User", () => {
  return jest.fn();
});

const UserModel = require("../src/models/User");

describe("User registration", () => {
  test("registers a new user successfully", async () => {
    const mockUser = {
      findOne: jest.fn().mockResolvedValue(null),
      create: jest.fn().mockResolvedValue({
        id: 1,
        name: "Test User",
        email: "test@example.com",
        password: "hashed-password"
      })
    };

    UserModel.mockReturnValue(mockUser);

    const userController = require("../src/controllers/userController")({});

    const req = {
      body: {
        name: "Test User",
        email: "test@example.com",
        password: "Password123!"
      }
    };

    const res = {
      status: jest.fn().mockReturnThis(),
      json: jest.fn()
    };

    await userController.register(req, res);

    expect(res.status).toHaveBeenCalledWith(201);
    expect(res.json).toHaveBeenCalledWith({
      message: "User registered successfully"
    });
  });

  test("rejects an existing user", async () => {
    const mockUser = {
      findOne: jest.fn().mockResolvedValue({
        id: 1,
        email: "existing@example.com"
      }),
      create: jest.fn()
    };

    UserModel.mockReturnValue(mockUser);

    const userController = require("../src/controllers/userController")({});

    const req = {
      body: {
        name: "Existing User",
        email: "existing@example.com",
        password: "Password123!"
      }
    };

    const res = {
      status: jest.fn().mockReturnThis(),
      json: jest.fn()
    };

    await userController.register(req, res);

    expect(res.status).toHaveBeenCalledWith(400);
    expect(res.json).toHaveBeenCalledWith({
      message: "User already exists"
    });
  });
});