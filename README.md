# 20SW032
# 20SW132

# Gadget Bazaar App

# Project Report

## Problem Identification

The problem faced by people is the manual process of purchasing gadgets. Traditional gadget purchasing methods involve physical stores, which can be time-consuming and often result in limited options. Customers may encounter the following issues:

Limited Availability: In physical stores, customers are constrained by the inventory available, which may not offer the latest or most diverse gadgets.

Inconvenience: Shopping for gadgets in physical stores can be time-consuming, requiring travel and potentially dealing with crowds.

Lack of Information: Physical stores might not provide sufficient information and reviews about the gadgets, making it difficult for customers to make informed decisions.

Payment Hassles: Traditional purchasing often involves carrying cash or credit cards, which can be inconvenient and potentially risky.

## Proposed Solution
Online Gadgets Marketplace: Gadget Bazaar will serve as an online marketplace where customers can browse and purchase a wide variety of gadgets. The app will provide access to a comprehensive catalog of gadgets, ranging from smartphones and laptops to smart home devices and wearables.

Convenient Shopping Experience: Customers can shop for gadgets from the comfort of their homes or on the go. They can explore product listings, read detailed descriptions, view images, and compare prices effortlessly.

Diverse Product Selection: Gadget Bazaar will source gadgets from multiple vendors and brands, ensuring a diverse and up-to-date product selection. Customers will have access to the latest tech innovations.

Informative Content: Product listings on the app will include detailed specifications, customer reviews, and expert opinions. This empowers customers to make well-informed decisions.

Secure Payments with Stripe: To ensure secure transactions, Gadget Bazaar will integrate the Stripe payment method. Stripe offers robust payment security, allowing customers to make purchases using credit cards, debit cards, or other payment options with confidence.

User-Friendly Interface: The app will feature an intuitive user interface, making it easy for users to search, filter, and sort gadgets based on their preferences. Customers can create accounts to save their preferences and order history for a seamless shopping experience.

Delivery and Returns: Gadget Bazaar will provide a reliable delivery service, ensuring that gadgets are delivered to the customer's doorstep. Additionally, an easy return process will be available in case of any issues or dissatisfaction with the purchased gadget.

## Responsive User Interfaces

Responsive Design: Gadget Bazaar boasts a responsive design that adapts effortlessly to various devices and screen sizes. Whether you're browsing on your smartphone, tablet, or desktop, our app ensures a consistent and visually pleasing experience.

Intuitive User Interface: We've prioritized user-friendliness, offering an intuitive and easy-to-navigate interface. With clear menus, well-organized categories, and a logical flow, you can quickly find the gadgets you're looking for.




![User Interface](https://github.com/osamamalik234/Gageget_Bazar_App/assets/93467529/e9905041-b4f2-4b74-b96f-b396e255eb89)

## Firebase Data Storage
I have used firebase database in which i have made three collections.

### 1. Users Collection:

Description: The user collection serves as a repository for user data. Each document in this collection represents a unique user of your app. It typically contains information about the user, including their name, email address, user ID, and any other user-specific data you want to store.
Fields:
user_id (Unique User Identifier)
name (User's Name)
email (User's Email Address)]
phone Number (User's Number)
Additional user profile information (e.g., address, contact details)
Any custom data related to the user
### 2. Product Categories Collection:

Description: The product_categories collection is used to organize and categorize the products available in your e-commerce app. Each document in this collection represents a product category. It's a useful structure for grouping and managing the different types of products you offer.
Fields:
category_id (Unique Category Identifier)
name (Category Name)
description (Category Description)
products (Subcollection or Reference to Products in this Category)
Subcollections: In this collection, you may use subcollections or references to individual products within each category. Each subcollection or reference represents a specific product within the category.

### 3. User Orders Collection:

Description: The user_orders collection is responsible for storing information related to orders made by your users. Each document in this collection represents a unique order, and it's associated with the user who placed the order. This collection helps in order history tracking and management.
Fields:
order_id (Unique Order Identifier)
user_id (Reference to the User Who Placed the Order)
order_date (Date and Time of Order)
order_status (Order Status, e.g., pending, shipped, delivered)
order_items (Array or Subcollection of Ordered Items)
total_amount (Order Total Amount)

### Stripe Payment Method API Integration

Secure Transactions: Stripe ensures that all payment transactions are highly secure, protecting sensitive customer data. It complies with industry standards for data protection and offers robust encryption and security features.

Payment Flexibility: With Stripe, the Gadget Bazaar app can accept a variety of payment methods, including credit cards, debit cards, and digital wallets, providing your customers with flexibility in how they make payments.


![Screenshot_20231009-135314_1](https://github.com/osamamalik234/Gageget_Bazar_App/assets/93467529/3f4f4ebb-3f91-4dd3-8aa3-453ab52f478b)

## Issue Encountered and Resolving During Development

 I faced an issue during development which is "multidex" issue when your project becomes too large and exceeds the method limit imposed by Android's Dalvik Executable (DEX) file format.

 ![download](https://github.com/osamamalik234/Gageget_Bazar_App/assets/93467529/0899348b-fe64-4fa3-b6f5-1bb2288861cf)


When this happens, you need to enable multidex support to avoid build errors. Here's how to resolve the multidex issue in a Flutter project:

### 1. Update Your build.gradle File:

You need to update the build.gradle files in your Flutter project. Follow these steps:

-> Open the android/app/build.gradle file in your project.
-> Inside the android block, add the following lines to enable multidex support:

<img width="247" alt="1" src="https://github.com/osamamalik234/Gageget_Bazar_App/assets/93467529/487b974b-ddb6-4639-b64b-15e5e80c1aab">

Then, add the multidex dependency in your dependencies block:

<img width="356" alt="2" src="https://github.com/osamamalik234/Gageget_Bazar_App/assets/93467529/62c79383-5001-4bff-b025-3c01283e6355">


