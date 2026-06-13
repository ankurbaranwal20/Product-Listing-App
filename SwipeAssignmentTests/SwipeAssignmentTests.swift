import Testing
@testable import SwipeAssignment

@Suite("Product Model Tests")
struct ProductTests {
    @Test("Product correctly initializes from parameters")
    func initializesWithAllFields() async throws {
        let product = Product(image: "image_url", price: "100.0", productName: "Laptop", productType: "Electronics", tax: "18.0")
        #expect(product.image == "image_url")
        #expect(product.price == "100.0")
        #expect(product.productName == "Laptop")
        #expect(product.productType == "Electronics")
        #expect(product.tax == "18.0")
        #expect(product.uploadImage == nil)
    }
}

@Suite("ProductList JSON Initialization Tests")
struct ProductListTests {
    @Test("ProductList parses valid JSON array, skipping invalid entries")
    func parsesAndFiltersValid() async throws {
        let json: [[String: Any]] = [
            ["image": "url1", "price": 150.0, "product_name": "Phone", "product_type": "Device", "tax": 10.0],
            ["image": "url2", "price": 20.0, "product_type": "Accessory", "tax": 2.0] // missing product_name
        ]
        let productList = ProductList(json: json)
        #expect(productList.products.count == 1)
        let product = productList.products.first!
        #expect(product.productName == "Phone")
        #expect(product.price == "150.0")
        #expect(product.tax == "10.0")
        #expect(product.productType == "Device")
    }
}

@Suite("AddProductViewModal Validation")
struct AddProductViewModalValidationTests {
    @Test("Empty productName validation fails")
    func emptyNameFails() async throws {
        let viewModel = AddProductViewModal()
        viewModel.addProduct.productName = ""
        #expect(!viewModel.validateFields())
        #expect(viewModel.errorMsg == "Please enter product name")
    }
    @Test("Empty productType validation fails")
    func emptyTypeFails() async throws {
        let viewModel = AddProductViewModal()
        viewModel.addProduct.productName = "Test"
        viewModel.addProduct.productType = ""
        #expect(!viewModel.validateFields())
        #expect(viewModel.errorMsg == "Please select product type from dropdown")
    }
    @Test("Empty price validation fails")
    func emptyPriceFails() async throws {
        let viewModel = AddProductViewModal()
        viewModel.addProduct.productName = "Test"
        viewModel.addProduct.productType = "Type"
        viewModel.addProduct.price = ""
        #expect(!viewModel.validateFields())
        #expect(viewModel.errorMsg == "Price can not be empty")
    }
    @Test("Empty tax validation fails")
    func emptyTaxFails() async throws {
        let viewModel = AddProductViewModal()
        viewModel.addProduct.productName = "Test"
        viewModel.addProduct.productType = "Type"
        viewModel.addProduct.price = "100"
        viewModel.addProduct.tax = ""
        #expect(!viewModel.validateFields())
        #expect(viewModel.errorMsg == "Please enter tax amount")
    }
    @Test("All fields valid passes validation")
    func allValidPasses() async throws {
        let viewModel = AddProductViewModal()
        viewModel.addProduct.productName = "Test"
        viewModel.addProduct.productType = "Type"
        viewModel.addProduct.price = "100"
        viewModel.addProduct.tax = "10"
        #expect(viewModel.validateFields())
        #expect(viewModel.errorMsg == nil)
    }
}
