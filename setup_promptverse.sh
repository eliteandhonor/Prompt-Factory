#!/bin/bash

echo "Creating PromptVerse project structure..."

# Create the main project directory
mkdir -p promptverse
cd promptverse || exit

echo "Created directory: promptverse/"

# Create subdirectories
mkdir -p js
mkdir -p data

echo "Created subdirectories: js/, data/"

# --- Create HTML files ---

# index.html
echo "Creating index.html..."
cat <<'EOF' > index.html
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>PromptVerse - Free Community Prompt Database</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        :root {
            --primary: #9c27b0;
            --primary-light: #bb86fc;
            --primary-dark: #6a0dad;
            --secondary: #03dac6;
            --background: #121212;
            --surface: #1e1e1e;
            --surface-light: #2d2d2d;
            --on-background: #e1e1e1;
            --on-surface: #ffffff;
            --error: #cf6679;
        }

        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background-color: var(--background);
            color: var(--on-background);
            line-height: 1.6;
        }

        a {
            color: var(--primary-light);
            text-decoration: none;
            transition: color 0.3s ease;
        }

        a:hover {
            color: var(--secondary);
        }

        .container {
            width: 90%;
            max-width: 1200px;
            margin: 0 auto;
            padding: 0 20px;
        }

        /* Header and Navigation */
        header {
            background-color: var(--surface);
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.3);
            position: sticky;
            top: 0;
            z-index: 100;
        }

        .navbar {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 1rem 0;
        }

        .logo {
            display: flex;
            align-items: center;
            font-size: 1.5rem;
            font-weight: bold;
            color: var(--primary-light);
        }

        .logo i {
            margin-right: 0.5rem;
            font-size: 1.8rem;
        }

        .nav-links {
            display: flex;
            list-style: none;
        }

        .nav-links li {
            margin-left: 1.5rem;
        }

        .nav-links a {
            color: var(--on-background);
            font-weight: 500;
            transition: color 0.3s ease;
        }

        .nav-links a:hover {
            color: var(--primary-light);
        }
        
        .nav-links a[href="manage-categories.html"],
        .nav-links a[href="community-guidelines.html"] {
            /* Special styling if needed for new links, or just ensure they fit */
        }


        .btn {
            display: inline-block;
            background-color: var(--primary);
            color: var(--on-surface);
            padding: 0.6rem 1.5rem;
            border-radius: 4px;
            font-weight: 500;
            cursor: pointer;
            transition: background-color 0.3s ease;
            border: none;
        }

        .btn:hover {
            background-color: var(--primary-dark);
            color: var(--on-surface);
        }

        .btn-outline {
            background-color: transparent;
            border: 1px solid var(--primary);
            color: var(--primary-light);
        }

        .btn-outline:hover {
            background-color: var(--primary);
            color: var(--on-surface);
        }

        /* Hero Section */
        .hero {
            padding: 5rem 0;
            text-align: center;
            background: linear-gradient(135deg, var(--surface) 0%, var(--surface-light) 100%);
            border-radius: 0 0 20px 20px;
            margin-bottom: 3rem;
        }

        .hero h1 {
            font-size: 3rem;
            margin-bottom: 1rem;
            color: var(--primary-light);
        }

        .hero p {
            font-size: 1.2rem;
            max-width: 700px;
            margin: 0 auto 2rem;
            color: var(--on-background);
        }

        .search-bar {
            display: flex;
            max-width: 600px;
            margin: 2rem auto;
            background-color: var(--surface-light);
            border-radius: 30px;
            padding: 0.5rem;
            box-shadow: 0 4px 10px rgba(0, 0, 0, 0.2);
        }

        .search-bar input {
            flex: 1;
            border: none;
            background: transparent;
            padding: 0.5rem 1rem;
            font-size: 1rem;
            color: var(--on-background);
            outline: none;
        }

        .search-bar button {
            background-color: var(--primary);
            border: none;
            color: white;
            padding: 0.5rem 1.5rem;
            border-radius: 30px;
            cursor: pointer;
            transition: background-color 0.3s ease;
        }

        .search-bar button:hover {
            background-color: var(--primary-dark);
        }

        /* Features Section */
        .features {
            padding: 4rem 0;
        }

        .section-title {
            text-align: center;
            margin-bottom: 3rem;
            color: var(--primary-light);
            font-size: 2rem;
        }

        .features-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 2rem;
        }

        .feature-card {
            background-color: var(--surface);
            border-radius: 10px;
            padding: 2rem;
            text-align: center;
            box-shadow: 0 4px 10px rgba(0, 0, 0, 0.2);
            transition: transform 0.3s ease, box-shadow 0.3s ease;
        }

        .feature-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 6px 15px rgba(0, 0, 0, 0.3);
        }

        .feature-icon {
            font-size: 2.5rem;
            color: var(--primary-light);
            margin-bottom: 1.5rem;
        }

        .feature-card h3 {
            font-size: 1.3rem;
            margin-bottom: 1rem;
            color: var(--on-surface);
        }

        .feature-card p {
            color: var(--on-background);
        }

        /* Popular Prompts Section */
        .popular-prompts {
            padding: 4rem 0;
        }

        .prompts-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
            gap: 2rem;
        }

        .prompt-card {
            background-color: var(--surface);
            border-radius: 10px;
            overflow: hidden;
            box-shadow: 0 4px 10px rgba(0, 0, 0, 0.2);
            transition: transform 0.3s ease, box-shadow 0.3s ease;
        }

        .prompt-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 6px 15px rgba(0, 0, 0, 0.3);
        }

        .prompt-header {
            background-color: var(--surface-light);
            padding: 1rem;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .prompt-title {
            font-size: 1.2rem;
            font-weight: 500;
            color: var(--on-surface);
        }

        .prompt-category {
            background-color: var(--primary-dark);
            color: var(--on-surface);
            padding: 0.3rem 0.8rem;
            border-radius: 15px;
            font-size: 0.8rem;
        }

        .prompt-content {
            padding: 1.5rem;
            color: var(--on-background);
            max-height: 150px;
            overflow: hidden;
            position: relative;
        }

        .prompt-content::after {
            content: '';
            position: absolute;
            bottom: 0;
            left: 0;
            width: 100%;
            height: 50px;
            background: linear-gradient(transparent, var(--surface));
        }

        .prompt-footer {
            padding: 1rem;
            display: flex;
            justify-content: space-between;
            align-items: center;
            border-top: 1px solid var(--surface-light);
        }

        .prompt-stats {
            display: flex;
            align-items: center;
            color: var(--on-background);
            font-size: 0.9rem;
        }

        .prompt-stats span {
            display: flex;
            align-items: center;
            margin-right: 1rem;
        }

        .prompt-stats i {
            margin-right: 0.3rem;
            color: var(--primary-light);
        }

        /* Categories Section */
        .categories {
            padding: 4rem 0;
        }

        .categories-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(150px, 1fr));
            gap: 1.5rem;
        }

        .category-card {
            background-color: var(--surface);
            border-radius: 10px;
            padding: 1.5rem;
            text-align: center;
            box-shadow: 0 4px 10px rgba(0, 0, 0, 0.2);
            transition: transform 0.3s ease, box-shadow 0.3s ease;
            cursor: pointer;
        }

        .category-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 6px 15px rgba(0, 0, 0, 0.3);
            background-color: var(--primary-dark);
        }

        .category-icon {
            font-size: 2rem;
            color: var(--primary-light);
            margin-bottom: 1rem;
        }

        .category-card h3 {
            font-size: 1.1rem;
            color: var(--on-surface);
        }

        /* Upload Section */
        .upload-section {
            padding: 4rem 0;
            background-color: var(--surface);
            border-radius: 20px;
            margin: 3rem 0;
        }

        .upload-container {
            max-width: 800px;
            margin: 0 auto;
            text-align: center;
        }

        .upload-area {
            border: 2px dashed var(--primary-light);
            border-radius: 10px;
            padding: 3rem;
            margin: 2rem 0;
            cursor: pointer;
            transition: background-color 0.3s ease;
        }

        .upload-area:hover {
            background-color: rgba(156, 39, 176, 0.1);
        }

        .upload-icon {
            font-size: 3rem;
            color: var(--primary-light);
            margin-bottom: 1rem;
        }

        .upload-text h3 {
            font-size: 1.5rem;
            margin-bottom: 0.5rem;
            color: var(--on-surface);
        }

        .upload-text p {
            color: var(--on-background);
            margin-bottom: 1rem;
        }

        .file-input {
            display: none;
        }

        .upload-options {
            display: flex;
            justify-content: center;
            gap: 1rem;
            margin-top: 1.5rem;
        }

        /* Footer */
        footer {
            background-color: var(--surface);
            padding: 3rem 0;
            margin-top: 4rem;
        }

        .footer-content {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 2rem;
        }

        .footer-column h3 {
            font-size: 1.2rem;
            margin-bottom: 1.5rem;
            color: var(--primary-light);
        }

        .footer-links {
            list-style: none;
        }

        .footer-links li {
            margin-bottom: 0.8rem;
        }

        .footer-links a {
            color: var(--on-background);
            transition: color 0.3s ease;
        }

        .footer-links a:hover {
            color: var(--primary-light);
        }

        .social-links {
            display: flex;
            gap: 1rem;
            margin-top: 1rem;
        }

        .social-links a {
            display: flex;
            align-items: center;
            justify-content: center;
            width: 40px;
            height: 40px;
            background-color: var(--surface-light);
            border-radius: 50%;
            color: var(--on-background);
            transition: background-color 0.3s ease, color 0.3s ease;
        }

        .social-links a:hover {
            background-color: var(--primary);
            color: var(--on-surface);
        }

        .copyright {
            text-align: center;
            margin-top: 3rem;
            padding-top: 1.5rem;
            border-top: 1px solid var(--surface-light);
            color: var(--on-background);
            font-size: 0.9rem;
        }

        /* Modal */
        .modal {
            display: none;
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background-color: rgba(0, 0, 0, 0.7);
            z-index: 1000;
            align-items: center;
            justify-content: center;
        }

        .modal-content {
            background-color: var(--surface);
            border-radius: 10px;
            width: 90%;
            max-width: 600px;
            padding: 2rem;
            box-shadow: 0 5px 20px rgba(0, 0, 0, 0.3);
            position: relative;
        }

        .close-modal {
            position: absolute;
            top: 1rem;
            right: 1rem;
            font-size: 1.5rem;
            color: var(--on-background);
            cursor: pointer;
            transition: color 0.3s ease;
        }

        .close-modal:hover {
            color: var(--error);
        }

        /* Responsive Design */
        @media (max-width: 768px) {
            .navbar {
                flex-direction: column;
                padding: 1rem 0;
            }

            .logo {
                margin-bottom: 1rem;
            }

            .nav-links {
                width: 100%;
                justify-content: space-around;
                flex-wrap: wrap; /* Allow wrapping for more links */
            }

            .nav-links li {
                margin: 0.5rem; /* Add some margin for wrapped items */
            }

            .hero h1 {
                font-size: 2.2rem;
            }

            .hero p {
                font-size: 1rem;
            }

            .feature-card,
            .prompt-card,
            .category-card {
                transform: none !important;
            }

            .upload-options {
                flex-direction: column;
            }
        }
    </style>
</head>
<body>
    <!-- Header -->
    <header>
        <div class="container">
            <nav class="navbar">
                <div class="logo">
                    <i class="fas fa-brain"></i>
                    <span>PromptVerse</span>
                </div>
                <ul class="nav-links">
                    <li><a href="#features">Features</a></li>
                    <li><a href="categories.html">Categories</a></li>
                    <li><a href="upload.html">Upload</a></li>
                    <li><a href="manage-categories.html">Manage Categories</a></li>
                    <li><a href="community-guidelines.html">Guidelines</a></li>
                </ul>
            </nav>
        </div>
    </header>

    <!-- Hero Section -->
    <section class="hero">
        <div class="container">
            <h1>Discover, Share & Collaborate on Prompts</h1>
            <p>PromptVerse is a free, community-driven database of prompts for AI, creative writing, and more. Upload your own or explore thousands of prompts shared by the community.</p>
            <div class="search-bar">
                <input type="text" id="mainSearchInput" placeholder="Search for prompts...">
                <button id="mainSearchButton"><i class="fas fa-search"></i> Search</button>
            </div>
            <div>
                <a href="upload.html" class="btn">Upload Prompt</a>
                <a href="#prompts" class="btn btn-outline">Explore Prompts</a>
            </div>
        </div>
    </section>

    <!-- Features Section -->
    <section class="features" id="features">
        <div class="container">
            <h2 class="section-title">Why PromptVerse?</h2>
            <div class="features-grid">
                <div class="feature-card">
                    <div class="feature-icon">
                        <i class="fas fa-upload"></i>
                    </div>
                    <h3>Easy Uploading</h3>
                    <p>Upload single or multiple .txt and .md files with just a few clicks.</p>
                </div>
                <div class="feature-card">
                    <div class="feature-icon">
                        <i class="fas fa-comments"></i>
                    </div>
                    <h3>Community Feedback</h3>
                    <p>Comment on prompts and share your results with the community.</p>
                </div>
                <div class="feature-card">
                    <div class="feature-icon">
                        <i class="fas fa-edit"></i>
                    </div>
                    <h3>Collaborative Editing</h3>
                    <p>Improve prompts together with community-based editing.</p>
                </div>
                <div class="feature-card">
                    <div class="feature-icon">
                        <i class="fas fa-folder-plus"></i>
                    </div>
                    <h3>Custom Categories</h3>
                    <p>Create and manage your own categories for better organization.</p>
                </div>
            </div>
        </div>
    </section>

    <!-- Popular Prompts Section -->
    <section class="popular-prompts" id="prompts">
        <div class="container">
            <h2 class="section-title">Popular Prompts</h2>
            <div class="prompts-grid" id="promptsGrid">
                <!-- Prompts will be loaded here by JavaScript -->
            </div>
            <div style="text-align: center; margin-top: 2rem;">
                <a href="#" class="btn" id="viewAllPromptsBtn">View All Prompts</a>
            </div>
        </div>
    </section>

    <!-- Categories Section -->
    <section class="categories" id="categories">
        <div class="container">
            <h2 class="section-title">Browse Categories</h2>
            <div class="categories-grid" id="categoriesGridHome">
                <!-- Categories will be loaded here by JavaScript -->
            </div>
             <div style="text-align: center; margin-top: 2rem;">
                <a href="categories.html" class="btn">View All Categories</a>
            </div>
        </div>
    </section>

    <!-- Upload Section (Simplified on Homepage) -->
    <section class="upload-section" id="upload">
        <div class="container">
            <div class="upload-container">
                <h2 class="section-title">Share Your Prompts</h2>
                <p>Contribute to the community by sharing your best prompts. Click below to get started.</p>
                <a href="upload.html" class="btn" style="margin-top: 1.5rem; padding: 1rem 2.5rem; font-size: 1.2rem;">
                    <i class="fas fa-cloud-upload-alt" style="margin-right: 0.5rem;"></i> Upload Now
                </a>
            </div>
        </div>
    </section>

    <!-- Footer -->
    <footer>
        <div class="container">
            <div class="footer-content">
                <div class="footer-column">
                    <h3>PromptVerse</h3>
                    <p>A free, community-driven database of prompts for AI, creative writing, and more.</p>
                    <div class="social-links">
                        <a href="#"><i class="fab fa-twitter"></i></a>
                        <a href="#"><i class="fab fa-github"></i></a>
                        <a href="#"><i class="fab fa-discord"></i></a>
                        <a href="#"><i class="fab fa-reddit"></i></a>
                    </div>
                </div>
                <div class="footer-column">
                    <h3>Navigation</h3>
                    <ulclass="footer-links">
                        <li><a href="#features">Features</a></li>
                        <li><a href="#prompts">Prompts</a></li>
                        <li><a href="categories.html">Categories</a></li>
                        <li><a href="upload.html">Upload</a></li>
                        <li>a href="manage-categories.html">Manage Categories</a></li>
                        <li><a href="community-guidelines.html">Guidelines</a></li>
                    </ul>
                </div>
                <div class="footer-column">
                    <h3>Resources</h3>
                    <ul class="footer-links">
                        <li><a href="#">Documentation</a></li><li><a href="#">API (Coming Soon)</a></li>
                        <li><a href="community-guidelines.html">Community Guidelines</a></li>
                        <li><a href="#">FAQ</a></li>
                    </ul>
                </div>
                <div class="footer-column">
                    <h3>Legal</h3>ul class="footer-links">
                        <li><a href="#">Terms of Service</a></li>
                        <li><a href="#">Privacy Policy</a></li>
                        <li><a href="#">Cookie Policy</a></li>
                    </ul>
                </div>
            </div>
            <div class="copyright">
                <p>&copy; 2025 PromptVerse. All rights reserved.</p>
            </div>
        </div>
    </footer>
    
    <script type="module">
        import db from './js/database.js';

        async function loadPopularPrompts() {
            await db.initDatabase(); // Ensure DB is initialized
            const promptsGrid = document.getElementById('promptsGrid');
            if (!promptsGrid) return;

            // Get prompts, sort by views (desc), take top 6
            let prompts = await db.getPrompts({ sortBy: 'views', sortOrder: 'desc' });
            prompts = prompts.slice(0, 6); 

            promptsGrid.innerHTML = ''; // Clear existing

            if (prompts.length === 0) {
                promptsGrid.innerHTML = '<p>No prompts available yet. Be the first to <a href="upload.html">upload one</a>!</p>';
                return;
            }

            for (const prompt of prompts) {
                const category = prompt.categoryId ? await db.getCategoryById(prompt.categoryId) : { name: 'Uncategorized' };
                const promptCard = document.createElement('div');
                promptCard.className = 'prompt-card';
                promptCard.innerHTML = \`
                    <div class="prompt-header">
                        <h3 class="prompt-title">\${prompt.title}</h3>
                        <span class="prompt-category">\${category ? category.name : 'Uncategorized'}</span>
                    </div>
                    <div class="prompt-content">
                        <p>\${prompt.content.substring(0, 150)}\${prompt.content.length > 150 ? '...' : ''}</p>
                    </div>
                    <div class="prompt-footer">
                        <div class="prompt-stats">
                            <span><i class="fas fa-eye"></i> \${prompt.views || 0}</span>
                            <span><i class="fas fa-star"></i> \${prompt.favoritesCount || 0}</span>
                        </div>
                        <a href="prompt-view.html?id=\${prompt.id}" class="btn btn-outline btn-sm">View</a>
                    </div>
                \`;
                promptsGrid.appendChild(promptCard);
            }
        }

        async function loadHomepageCategories() {
            await db.initDatabase();
            const categoriesGrid = document.getElementById('categoriesGridHome');
            if (!categoriesGrid) return;

            let categories = await db.getCategories({ status: 'approved' }); // Or 'official' and 'approved'
             // Sort by prompt count, take top 8 or so
            categories.sort((a, b) => (b.promptCount || 0) - (a.promptCount || 0));
            categories = categories.slice(0, 8);

            categoriesGrid.innerHTML = '';

            if (categories.length === 0) {
                categoriesGrid.innerHTML = '<p>No categories available yet.</p>';
                return;
            }
            
            categories.forEach(category => {
                const categoryCard = document.createElement('div');
                categoryCard.className = 'category-card';
                categoryCard.innerHTML = \`
                    <div class="category-icon">i class="\${category.icon || 'fas fa-folder'}"></i>
                    </div>
                    <h3>\${category.name}</h3>
                    <p>(\${(category.promptCount || 0)} prompts)</p>
                \`;
                categoryCard.addEventListener('click', () => {
                    window.location.href = \`categories.html#category-\${category.id}\`; // Link to specific category on categories page
                });
                categoriesGrid.appendChild(categoryCard);
            });
        }
        
        document.addEventListener('DOMContentLoaded', () => {
            loadPopularPrompts();
            loadHomepageCategories();

            const mainSearchButton = document.getElementById('mainSearchButton');
            const mainSearchInput = document.getElementById('mainSearchInput');

            if(mainSearchButton && mainSearchInput) {
                mainSearchButton.addEventListener('click', () => {
                    const searchTerm = mainSearchInput.value.trim();
                    if (searchTerm) {
                        // Redirect to a search results page (to be created) or filter on prompts page
                        // For now, let's assume a prompts list page that can filter
                        window.location.href = \`prompts-list.html?search=\${encodeURIComponent(searchTerm)}\`;
                    }
                });
                mainSearchInput.addEventListener('keypress', (e) => {
                    if (e.key === 'Enter') {
                        mainSearchButton.click();
                    }
                });
            }
            
            // View All Prompts Button (if it exists and we have a page for it)
            const viewAllPromptsBtn = document.getElementById('viewAllPromptsBtn');
            if (viewAllPromptsBtn) {
                viewAllPromptsBtn.addEventListener('click', (e) => {
                    e.preventDefault();
                    window.location.href = 'prompts-list.html'; // Assuming a page that lists all prompts
                });
            }
        });
    </script>
</body>
</html>
EOF

# prompt-view.html
echo "Creating prompt-view.html..."
cat <<'EOF' > prompt-view.html
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Prompt Details - PromptVerse</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        :root {
            --primary: #9c27b0;
            --primary-light: #bb86fc;
            --primary-dark: #6a0dad;
            --secondary: #03dac6;
            --background: #121212;
            --surface: #1e1e1e;
            --surface-light: #2d2d2d;
            --on-background: #e1e1e1;
            --on-surface: #ffffff;
            --error: #cf6679;
        }

        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background-color: var(--background);
            color: var(--on-background);
            line-height: 1.6;
        }

        a {
            color: var(--primary-light);
            text-decoration: none;
            transition: color 0.3s ease;
        }

        a:hover {
            color: var(--secondary);
        }

        .container {
            width: 90%;
            max-width: 1200px;
            margin: 0 auto;
            padding: 0 20px;
        }

        /* Header and Navigation */
        header {
            background-color: var(--surface);
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.3);
            position: sticky;
            top: 0;
            z-index: 100;
        }

        .navbar {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 1rem 0;
        }

        .logo {
            display: flex;
            align-items: center;
            font-size: 1.5rem;
            font-weight: bold;
            color: var(--primary-light);
        }

        .logo i {
            margin-right: 0.5rem;
            font-size: 1.8rem;
        }

        .nav-links {
            display: flex;
            list-style: none;
        }

        .nav-links li {
            margin-left: 1.5rem;
        }

        .nav-links a {
            color: var(--on-background);
            font-weight: 500;
            transition: color 0.3s ease;
        }
        
        .nav-links a[href="manage-categories.html"],
        .nav-links a[href="community-guidelines.html"] {
            /* Special styling if needed for new links, or just ensure they fit */
        }

        .nav-links a:hover {
            color: var(--primary-light);
        }

        .btn {
            display: inline-block;
            background-color: var(--primary);
            color: var(--on-surface);
            padding: 0.6rem 1.5rem;
            border-radius: 4px;
            font-weight: 500;
            cursor: pointer;
            transition: background-color 0.3s ease;
            border: none;
        }

        .btn:hover {
            background-color: var(--primary-dark);
            color: var(--on-surface);
        }

        .btn-outline {
            background-color: transparent;
            border: 1px solid var(--primary);
            color: var(--primary-light);
        }

        .btn-outline:hover {
            background-color: var(--primary);
            color: var(--on-surface);
        }

        .btn-sm {
            padding: 0.4rem 1rem;
            font-size: 0.9rem;
        }

        /* Breadcrumbs */
        .breadcrumbs {
            display: flex;
            align-items: center;
            padding: 1rem 0;
            font-size: 0.9rem;
        }

        .breadcrumbs a {
            color: var(--primary-light);
        }

        .breadcrumbs span {
            margin: 0 0.5rem;
            color: var(--on-background);
        }

        /* Prompt View */
        .prompt-view {
            background-color: var(--surface);
            border-radius: 10px;
            margin: 2rem 0;
            overflow: hidden;
            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.2);
        }

        .prompt-header-main { /* Renamed from .prompt-header to avoid conflict */
            padding: 2rem;
            background: linear-gradient(135deg, var(--primary-dark) 0%, var(--primary) 100%);
            color: var(--on-surface);
            position: relative;
        }

        .prompt-title-main { /* Renamed */
            font-size: 2rem;
            margin-bottom: 0.5rem;
        }

        .prompt-meta {
            display: flex;
            align-items: center;
            flex-wrap: wrap;
            gap: 1.5rem;
            margin-top: 1rem;
        }

        .prompt-meta-item {
            display: flex;
            align-items: center;
            font-size: 0.9rem;
        }

        .prompt-meta-item i {
            margin-right: 0.5rem;
        }

        .prompt-category-display { /* Renamed */
            background-color: rgba(255, 255, 255, 0.2);
            padding: 0.3rem 1rem;
            border-radius: 20px;
            font-size: 0.9rem;
            display: inline-block;
        }

        .prompt-tags {
            display: flex;
            flex-wrap: wrap;
            gap: 0.5rem;
            margin-top: 1rem;
        }

        .prompt-tag {
            background-color: rgba(255, 255, 255, 0.1);
            padding: 0.2rem 0.8rem;
            border-radius: 15px;
            font-size: 0.8rem;
        }

        .prompt-actions {
            position: absolute;
            top: 2rem;
            right: 2rem;
            display: flex;
            gap: 1rem;
        }

        .prompt-action-btn {
            background-color: rgba(255, 255, 255, 0.2);
            color: var(--on-surface);
            width: 40px;
            height: 40px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            cursor: pointer;
            transition: background-color 0.3s ease;
            border: none; /* Ensure it's a button */
        }

        .prompt-action-btn:hover {
            background-color: rgba(255, 255, 255, 0.3);
        }

        .prompt-content-container {
            padding: 2rem;
        }

        .prompt-content-display { /* Renamed */
            background-color: var(--surface-light);
            padding: 2rem;
            border-radius: 8px;
            white-space: pre-wrap;
            font-family: 'Courier New', Courier, monospace;
            line-height: 1.8;
            min-height: 150px; /* Ensure some height */
        }

        .prompt-content-editable {
            background-color: var(--surface-light);
            padding: 2rem;
            border-radius: 8px;
            white-space: pre-wrap;
            font-family: 'Courier New', Courier, monospace;
            line-height: 1.8;
            border: 1px solid var(--primary-light);
            outline: none;
            min-height: 200px;
            display: none; /* Hidden by default */
            width: 100%; /* Take full width */
            color: var(--on-surface); /* Ensure text is visible */
        }


        .edit-actions {
            display: none; /* Hidden by default */
            margin-top: 1rem;
            text-align: right;
        }
        
        .edit-reason-input {
            width: 100%;
            padding: 0.8rem;
            border-radius: 5px;
            border: 1px solid var(--surface-light);
            background-color: var(--surface-light);
            color: var(--on-background);
            font-family: inherit;
            margin-bottom: 1rem;
            display: none; /* Hidden by default */
        }


        /* Tabs */
        .tabs {
            display: flex;
            border-bottom: 1px solid var(--surface-light);
            margin-bottom: 2rem;
        }

        .tab {
            padding: 1rem 2rem;
            cursor: pointer;
            transition: all 0.3s ease;
            border-bottom: 2px solid transparent;
            font-weight: 500;
        }

        .tab.active {
            color: var(--primary-light);
            border-bottom: 2px solid var(--primary-light);
        }

        .tab-content {
            display: none;
        }

        .tab-content.active {
            display: block;
        }

        /* Comments Section */
        .comments-section {
            padding: 2rem;
        }

        .comment {
            background-color: var(--surface-light);
            border-radius: 8px;
            padding: 1.5rem;
            margin-bottom: 1.5rem;
        }

        .comment-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 1rem;
        }

        .comment-author {
            display: flex;
            align-items: center;
        }

        .author-avatar {
            width: 40px;
            height: 40px;
            border-radius: 50%;
            background-color: var(--primary);
            display: flex;
            align-items: center;
            justify-content: center;
            color: var(--on-surface);
            font-weight: bold;
            margin-right: 1rem;
            overflow: hidden; /* For images */
        }
        .author-avatar img {
            width: 100%;
            height: 100%;
            object-fit: cover;
        }


        .author-name {
            font-weight: 500;
        }

        .comment-date {
            font-size: 0.9rem;
            color: var(--on-background);
            opacity: 0.7;
        }
        
        .comment-content-text { /* Added for comment text */
             white-space: pre-wrap;
        }

        .comment-actions {
            display: flex;
            gap: 1rem;
            margin-top: 1rem;
        }

        .comment-action {
            display: flex;
            align-items: center;
            color: var(--on-background);
            opacity: 0.7;
            cursor: pointer;
            transition: opacity 0.3s ease;
            border: none; /* Ensure it's a button */
            background: none; /* Ensure it's a button */
            padding: 0; /* Ensure it's a button */
            font-size: 0.9rem; /* Ensure it's a button */
        }
        .comment-action.active { /* For active vote buttons */
            color: var(--primary-light);
            opacity: 1;
        }


        .comment-action:hover {
            opacity: 1;
            color: var(--primary-light);
        }

        .comment-action i {
            margin-right: 0.5rem;
        }

        .add-comment {
            margin-top: 2rem;
        }

        .comment-textarea {
            width: 100%;
            padding: 1rem;
            border-radius: 8px;
            background-color: var(--surface-light);
            border: 1px solid var(--surface-light);
            color: var(--on-background);
            min-height: 100px;
            resize: vertical;
            margin-bottom: 1rem;
            transition: border-color 0.3s ease;
        }

        .comment-textarea:focus {
            border-color: var(--primary-light);
            outline: none;
        }

        /* Outputs Section */
        .outputs-section {
            padding: 2rem;
        }

        .output {
            background-color: var(--surface-light);
            border-radius: 8px;
            padding: 1.5rem;
            margin-bottom: 1.5rem;
        }

        .output-content-text { /* Renamed */
            background-color: rgba(0, 0, 0, 0.2);
            padding: 1.5rem;
            border-radius: 8px;
            white-space: pre-wrap;
            font-family: 'Courier New', Courier, monospace;
            line-height: 1.6;
            margin-top: 1rem;
        }

        .add-output {
            margin-top: 2rem;
        }
        
        .output-textarea { /* Same as comment-textarea */
            width: 100%;
            padding: 1rem;
            border-radius: 8px;
            background-color: var(--surface-light);
            border: 1px solid var(--surface-light);
            color: var(--on-background);
            min-height: 100px;
            resize: vertical;
            margin-bottom: 1rem;
            transition: border-color 0.3s ease;
        }
        .output-textarea:focus {
            border-color: var(--primary-light);
            outline: none;
        }


        /* Related Prompts */
        .related-prompts {
            padding: 3rem 0;
        }
        
        .section-title { /* General section title */
            text-align: center;
            margin-bottom: 3rem;
            color: var(--primary-light);
            font-size: 2rem;
        }

        .related-prompts-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
            gap: 2rem;
        }

        .prompt-card { /* Reusing prompt card style from index */
            background-color: var(--surface);
            border-radius: 10px;
            overflow: hidden;
            box-shadow: 0 4px 10px rgba(0, 0, 0, 0.2);
            transition: transform 0.3s ease, box-shadow 0.3s ease;
        }

        .prompt-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 6px 15px rgba(0, 0, 0, 0.3);
        }

        .prompt-card-header {
            background-color: var(--surface-light);
            padding: 1rem;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .prompt-card-title {
            font-size: 1.2rem;
            font-weight: 500;
            color: var(--on-surface);
        }

        .prompt-card-category {
            background-color: var(--primary-dark);
            color: var(--on-surface);
            padding: 0.3rem 0.8rem;
            border-radius: 15px;
            font-size: 0.8rem;
        }

        .prompt-card-content {
            padding: 1.5rem;
            color: var(--on-background);
            max-height: 100px; /* Shorter for related prompts */
            overflow: hidden;
            position: relative;
        }

        .prompt-card-content::after {
            content: '';
            position: absolute;
            bottom: 0;
            left: 0;
            width: 100%;
            height: 30px; /* Shorter fade */
            background: linear-gradient(transparent, var(--surface));
        }

        .prompt-card-footer {
            padding: 1rem;
            display: flex;
            justify-content: space-between;
            align-items: center;
            border-top: 1px solid var(--surface-light);
        }

        .prompt-card-stats {
            display: flex;
            align-items: center;
            color: var(--on-background);
            font-size: 0.9rem;
        }

        .prompt-card-stats span {
            display: flex;
            align-items: center;
            margin-right: 1rem;
        }

        .prompt-card-stats i {
            margin-right: 0.3rem;
            color: var(--primary-light);
        }

        /* Footer */
        footer {
            background-color: var(--surface);
            padding: 3rem 0;
            margin-top: 4rem;
        }

        .footer-content {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 2rem;
        }

        .footer-column h3 {
            font-size: 1.2rem;
            margin-bottom: 1.5rem;
            color: var(--primary-light);
        }

        .footer-links {
            list-style: none;
        }

        .footer-links li {
            margin-bottom: 0.8rem;
        }

        .footer-links a {
            color: var(--on-background);
            transition: color 0.3s ease;
        }

        .footer-links a:hover {
            color: var(--primary-light);
        }

        .social-links {
            display: flex;
            gap: 1rem;
            margin-top: 1rem;
        }

        .social-links a {
            display: flex;
            align-items: center;
            justify-content: center;
            width: 40px;
            height: 40px;
            background-color: var(--surface-light);
            border-radius: 50%;
            color: var(--on-background);
            transition: background-color 0.3s ease, color 0.3s ease;
        }

        .social-links a:hover {
            background-color: var(--primary);
            color: var(--on-surface);
        }

        .copyright {
            text-align: center;
            margin-top: 3rem;
            padding-top: 1.5rem;
            border-top: 1px solid var(--surface-light);
            color: var(--on-background);
            font-size: 0.9rem;
        }

        /* Modal */
        .modal {
            display: none;
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background-color: rgba(0, 0, 0, 0.7);
            z-index: 1000;
            align-items: center;
            justify-content: center;
        }
        
        .modal.active { /* Added for JS control */
            display: flex;
        }

        .modal-content {
            background-color: var(--surface);
            border-radius: 10px;
            width: 90%;
            max-width: 600px;
            padding: 2rem;
            box-shadow: 0 5px 20px rgba(0, 0, 0, 0.3);
            position: relative;
        }

        .close-modal {
            position: absolute;
            top: 1rem;
            right: 1rem;
            font-size: 1.5rem;
            color: var(--on-background);
            cursor: pointer;
            transition: color 0.3s ease;
        }

        .close-modal:hover {
            color: var(--error);
        }
        
        /* Version History Item */
        .version-item {
            background-color: var(--surface-light);
            border-radius: 8px;
            padding: 1.5rem;
            margin-bottom: 1.5rem;
        }
        .version-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 1rem;
        }
        .version-info .version-number {
            font-weight: bold;
            color: var(--on-surface);
        }
        .version-info .version-meta {
            font-size: 0.9rem;
            color: var(--on-background);
            opacity: 0.8;
        }
        .version-content {
            background-color: rgba(0,0,0,0.2);
            padding: 1rem;
            border-radius: 5px;
            white-space: pre-wrap;
            font-family: 'Courier New', Courier, monospace;
            max-height: 200px;
            overflow-y: auto;
        }
        .version-reason {
            margin-top: 0.5rem;
            font-style: italic;
            font-size: 0.9rem;
            color: var(--on-background);
            opacity: 0.7;
        }
        .version-actions {
            margin-top: 1rem;
            text-align: right;
        }


        /* Responsive Design */
        @media (max-width: 768px) {
            .navbar {
                flex-direction: column;
                padding: 1rem 0;
            }

            .logo {
                margin-bottom: 1rem;
            }

            .nav-links {
                width: 100%;
                justify-content: space-around;
                flex-wrap: wrap; /* Allow wrapping for more links */
            }

            .nav-links li {
                margin: 0.5rem; /* Add some margin for wrapped items */
            }

            .prompt-actions {
                position: static;
                margin-top: 1.5rem;
                justify-content: flex-end;
            }

            .tabs {
                overflow-x: auto;
                white-space: nowrap;
                -webkit-overflow-scrolling: touch; /* For smoother scrolling on iOS */
            }
            .tabs::-webkit-scrollbar { /* Hide scrollbar for a cleaner look */
                display: none;
            }
            .tabs {
                -ms-overflow-style: none;  /* IE and Edge */
                scrollbar-width: none;  /* Firefox */
            }


            .tab {
                padding: 1rem;
            }

            .prompt-card {
                transform: none !important;
            }
        }
    </style>
</head>
<body>
    <!-- Header -->
    <header>
        <div class="container">
            <nav class="navbar">
                <div class="logo">
                    <i class="fas fa-brain"></i>
                    <span>PromptVerse</span>
                </div>
                <ul class="nav-links">
                    <li><a href="index.html">Home</a></li>
                    <li><a href="categories.html">Categories</a></li>
                    <li><a href="upload.html">Upload</a></li>
                    <li><a href="manage-categories.html">Manage Categories</a></li>
                    <li><a href="community-guidelines.html">Guidelines</a></li>
                </ul>
            </nav>
        </div>
    </header>

    <!-- Main Content -->
    <main class="container"id="mainContent">
        <!-- Breadcrumbs -->
        <div class="breadcrumbs" id="breadcrumbsContainer">
            <a href="index.html">Home</a>
            <span>/</span>
            <a href="categories.html" id="breadcrumbCategoryLink">Prompts</a>
            <span>/</span>span id="breadcrumbPromptTitle">Loading Prompt...</span>
        </div>

        <!-- Prompt View -->
        <section class="prompt-view">
            <div class="prompt-header-main" id="promptHeaderMain">
                <h1 class="prompt-title-main" id="promptTitle">Loading...</h1>
                <span class="prompt-category-display" id="promptCategoryDisplay">Loading...</span>
                <div class="prompt-tags" id="promptTagsContainer">
                    <!-- Tags will be loaded here -->
                </div>
                <div class="prompt-meta" id="promptMetaContainer">
                    <!-- Meta items will be loaded here -->
                </div>
                <div class="prompt-actions">
                    <button class="prompt-action-btn" id="editPromptBtn" title="Edit Prompt">
                        <i class="fas fa-edit"></i>
                    </button>button class="prompt-action-btn" id="sharePromptBtn" title="Share Prompt">
                        <i class="fas fa-share-alt"></i>
                    </button>
                    <button class="prompt-action-btn" id="favoritePromptBtn" title="Add to Favorites">
                        <i class="far fa-star"></i> <!-- fas fa-star for favorited -->
                    </button>
                    <button class="prompt-action-btn" id="downloadPromptBtn" title="Download Prompt">
                        <i class="fas fa-download"></i>
                    </button>
                </div>
            </div>div class="prompt-content-container">
                <div class="prompt-content-display" id="promptContentDisplay">
                    Loading prompt content...
                </div>
                <textarea class="prompt-content-editable" id="promptContentEditable"></textarea>
                <input type="text" class="edit-reason-input" id="editReasonInput" placeholder="Reason for editing (e.g., fixed typo, added clarity)">
                <div class="edit-actions" id="editActions">
                    <button class="btn btn-outline btn-sm" id="cancelEditBtn">Cancel</button>
                    <button class="btn btn-sm" id="saveEditBtn">Save Changes</button>
                </div>
            </div>

            <!-- Tabs -->
            <div class="tabs">
                <div class="tab active" data-tab="comments">Comments (<span id="commentsCount">0</span>)</div>
                <div class="tab" data-tab="outputs">Outputs (<span id="outputsCount">0</span>)</div>
                <div class="tab" data-tab="versions">Version History (<span id="versionsCount">0</span>)</div>
            </div>

            <!-- Comments Section -->
            <div class="tab-content active" id="commentsTab">
                <div class="comments-section">
                    <div id="commentsList">
                        <!-- Comments will be loaded here -->
                    </div>
                    <div class="add-comment">
                        <h3>Add a Comment</h3>
                        <textarea class="comment-textarea" id="newCommentTextarea" placeholder="Share your thoughts about this prompt..."></textarea>
                        <button class="btn" id="postCommentBtn">Post Comment</button>
                    </div>
                </div>
            </div>

            <!-- Outputs Section -->
            <div class="tab-content" id="outputsTab">
                <div class="outputs-section">
                     <div id="outputsList">
                        <!-- Outputs will be loaded here -->
                    </div>
                    <div class="add-output">
                        <h3>Share Your Output</h3>
                        <textarea class="output-textarea" id="newOutputTextarea" placeholder="Share what you created with this prompt..."></textarea>
                        <button class="btn" id="postOutputBtn">Post Output</button>
                    </div>
                </div>
            </div>

            <!-- Versions Section -->
            <div class="tab-content" id="versionsTab">
