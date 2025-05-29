// Simulates a database using localStorage and interacts with data as if they were JSON files.
// For a real multi-user, persistent database, a backend server would be required.

const DB_PREFIX = 'promptVerseDB_';
const PROMPTS_KEY = `${DB_PREFIX}prompts`;
const CATEGORIES_KEY = `${DB_PREFIX}categories`;
const USERS_KEY = `${DB_PREFIX}users`;
const COMMENTS_KEY = `${DB_PREFIX}comments`;
const OUTPUTS_KEY = `${DB_PREFIX}outputs`;
const FAVORITES_KEY = `${DB_PREFIX}favorites`; // Stores { promptId, userId }
const VOTES_KEY = `${DB_PREFIX}votes`; // Stores { itemId, itemType ('category'|'comment'|'output'), userId, voteType ('up'|'down') }

const MOCK_DATA_PATH = './data/'; // Adjusted path for script execution from root

// --- Helper Functions ---
function _generateId() {
    return Date.now().toString(36) + Math.random().toString(36).substring(2);
}

async function _getData(key) {
    try {
        const data = localStorage.getItem(key);
        return data ? JSON.parse(data) : [];
    } catch (error) {
        console.error(`Error reading data from localStorage for key ${key}:`, error);
        return [];
    }
}

async function _setData(key, data) {
    try {
        localStorage.setItem(key, JSON.stringify(data));
        return true;
    } catch (error) {
        console.error(`Error writing data to localStorage for key ${key}:`, error);
        return false;
    }
}

async function _fetchInitialData(fileName) {
    try {
        const response = await fetch(`${MOCK_DATA_PATH}${fileName}`);
        if (!response.ok) {
            console.warn(`Could not fetch initial data for ${fileName}. Status: ${response.status}`);
            return [];
        }
        const text = await response.text();
        if (!text) { // Handle empty file case
             console.warn(`Initial data file ${fileName} is empty.`);
             return [];
        }
        return JSON.parse(text);
    } catch (error) {
        console.warn(`Error fetching or parsing initial data for ${fileName}:`, error);
        return [];
    }
}

// --- Database Initialization ---
let dbInitialized = false;
async function initDatabase() {
    if (dbInitialized) return;

    const keysToInitialize = [
        { key: PROMPTS_KEY, file: 'prompts.json' },
        { key: CATEGORIES_KEY, file: 'categories.json' },
        { key: USERS_KEY, file: 'users.json' },
        { key: COMMENTS_KEY, file: 'comments.json' },
        { key: OUTPUTS_KEY, file: 'outputs.json' },
        { key: FAVORITES_KEY, file: 'favorites.json' },
        { key: VOTES_KEY, file: 'votes.json' },
    ];

    for (const item of keysToInitialize) {
        if (localStorage.getItem(item.key) === null) { // Check for null to ensure it runs only once
            console.log(`Initializing ${item.key} from ${item.file}...`);
            const initialData = await _fetchInitialData(item.file);
            await _setData(item.key, initialData || []); // Ensure an empty array if fetching fails or returns undefined/null
        }
    }
    // Ensure a default "Uncategorized" category exists if no categories were loaded
    const categories = await _getData(CATEGORIES_KEY);
    const uncategorizedExists = categories.some(cat => cat.id === 'uncategorized');
    if (!uncategorizedExists) {
        categories.push({
            id: 'uncategorized',
            name: 'Uncategorized',
            description: 'Prompts that have not yet been categorized.',
            icon: 'fas fa-question-circle',
            color: '#757575',
            promptCount: 0,
            status: 'official',
            subcategories: [],
            tags: [],
            createdBy: 'system',
            createdDate: new Date().toISOString(),
            updatedDate: new Date().toISOString(),
            upvotes: 0,
            downvotes: 0
        });
        await _setData(CATEGORIES_KEY, categories);
    }
    dbInitialized = true;
    console.log("Database initialized (simulated with localStorage).");
}

// --- User Functions ---
let currentUserId = 'user_default_anonymous'; // Placeholder

async function getCurrentUser() {
    let users = await _getData(USERS_KEY);
    let user = users.find(u => u.id === currentUserId);
    if (!user) {
        // Create a default anonymous user if not found
        user = {
            id: currentUserId,
            username: 'Anonymous User',
            email: 'anonymous@promptverse.example.com',
            profilePicture: 'https://i.pravatar.cc/150?u=anonymous',
            joinDate: new Date().toISOString(),
            bio: 'A guest exploring PromptVerse.',
            role: 'guest',
            lastLogin: new Date().toISOString(),
            preferences: { theme: 'dark', notifications: false }
        };
        users.push(user);
        await _setData(USERS_KEY, users);
    }
    return user;
}
async function setCurrentUserId(userId) { // For testing/simulation
    currentUserId = userId;
    // Optionally, re-fetch/validate current user
    return await getCurrentUser();
}


async function getUserById(userId) {
    const users = await _getData(USERS_KEY);
    return users.find(u => u.id === userId) || null;
}

async function addUser(userData) {
    const users = await _getData(USERS_KEY);
    const existingUser = users.find(u => u.username === userData.username || u.email === userData.email);
    if (existingUser) {
        console.warn("User with this username or email already exists.");
        return null; // Or throw an error
    }
    const newUser = {
        id: _generateId(),
        joinDate: new Date().toISOString(),
        lastLogin: new Date().toISOString(),
        promptsUploaded: 0,
        commentsMade: 0,
        outputsShared: 0,
        role: 'member',
        preferences: { theme: 'dark', notifications: true },
        ...userData
    };
    users.push(newUser);
    await _setData(USERS_KEY, users);
    return newUser;
}


// --- Prompt Functions ---
async function getPrompts(filters = {}) {
    let prompts = await _getData(PROMPTS_KEY);
    if (filters.categoryId && filters.categoryId !== 'all') {
        prompts = prompts.filter(p => p.categoryId === filters.categoryId);
    }
    if (filters.subcategoryId) {
        prompts = prompts.filter(p => p.subcategoryId === filters.subcategoryId);
    }
    if (filters.userId) {
        prompts = prompts.filter(p => p.userId === filters.userId);
    }
    if (filters.tags && filters.tags.length > 0) {
        prompts = prompts.filter(p => p.tags && filters.tags.every(tag => p.tags.includes(tag)));
    }
    if (filters.searchTerm) {
        const term = filters.searchTerm.toLowerCase();
        prompts = prompts.filter(p =>
            p.title.toLowerCase().includes(term) ||
            p.content.toLowerCase().includes(term) ||
            (p.description && p.description.toLowerCase().includes(term))
        );
    }
    if (filters.difficulty) {
        prompts = prompts.filter(p => p.difficulty === filters.difficulty);
    }

    if (filters.sortBy) {
        prompts.sort((a, b) => {
            let valA, valB;
            if (filters.sortBy === 'title') {
                valA = a.title.toLowerCase(); valB = b.title.toLowerCase();
            } else if (filters.sortBy === 'createdDate' || filters.sortBy === 'recent') {
                valA = new Date(a.createdDate); valB = new Date(b.createdDate);
            } else if (filters.sortBy === 'updatedDate') {
                valA = new Date(a.updatedDate); valB = new Date(b.updatedDate);
            } else if (filters.sortBy === 'views' || filters.sortBy === 'favoritesCount') {
                valA = a[filters.sortBy] || 0; valB = b[filters.sortBy] || 0;
            } else {
                valA = a[filters.sortBy]; valB = b[filters.sortBy];
            }

            if (filters.sortOrder === 'asc') {
                return valA > valB ? 1 : (valA < valB ? -1 : 0);
            }
            return valB > valA ? 1 : (valB < valA ? -1 : 0); // Default desc
        });
    }
    return prompts;
}

async function getPromptById(id) {
    const prompts = await _getData(PROMPTS_KEY);
    return prompts.find(p => p.id === id) || null;
}

async function addPrompt(promptData) {
    const prompts = await _getData(PROMPTS_KEY);
    const user = await getCurrentUser();
    const newPrompt = {
        id: _generateId(),
        userId: user.id,
        createdDate: new Date().toISOString(),
        updatedDate: new Date().toISOString(),
        views: 0,
        favoritesCount: 0,
        versionHistory: [],
        tags: promptData.tags || [],
        difficulty: promptData.difficulty || 'intermediate',
        license: promptData.license || 'cc-by',
        allowEdits: typeof promptData.allowEdits === 'boolean' ? promptData.allowEdits : true,
        allowComments: typeof promptData.allowComments === 'boolean' ? promptData.allowComments : true,
        showAuthor: typeof promptData.showAuthor === 'boolean' ? promptData.showAuthor : true,
        ...promptData
    };
    newPrompt.versionHistory.push({
        version: 1,
        content: newPrompt.content,
        userId: user.id,
        date: newPrompt.createdDate,
        reason: 'Initial creation'
    });
    prompts.push(newPrompt);
    await _setData(PROMPTS_KEY, prompts);

    if (newPrompt.categoryId) {
        await _updateCategoryPromptCount(newPrompt.categoryId, 1);
    }
    if (newPrompt.subcategoryId) {
        await _updateSubCategoryPromptCount(newPrompt.categoryId, newPrompt.subcategoryId, 1);
    }
    return newPrompt;
}

async function updatePrompt(id, updatedData) {
    let prompts = await _getData(PROMPTS_KEY);
    const promptIndex = prompts.findIndex(p => p.id === id);
    if (promptIndex === -1) return null;

    const user = await getCurrentUser();
    const oldPrompt = { ...prompts[promptIndex] }; // Shallow copy for comparison

    const updatedPrompt = {
        ...oldPrompt,
        ...updatedData,
        id: oldPrompt.id,
        updatedDate: new Date().toISOString(),
    };

    if (updatedData.content && updatedData.content !== oldPrompt.content) {
        updatedPrompt.versionHistory = updatedPrompt.versionHistory || [];
        updatedPrompt.versionHistory.push({
            version: updatedPrompt.versionHistory.length + 1,
            content: updatedData.content,
            userId: user.id,
            date: updatedPrompt.updatedDate,
            reason: updatedData.editReason || 'Content updated'
        });
    }

    prompts[promptIndex] = updatedPrompt;
    await _setData(PROMPTS_KEY, prompts);

    // Update category/subcategory counts if they changed
    if (updatedPrompt.categoryId !== oldPrompt.categoryId || updatedPrompt.subcategoryId !== oldPrompt.subcategoryId) {
        if (oldPrompt.categoryId) await _updateCategoryPromptCount(oldPrompt.categoryId, -1);
        if (oldPrompt.subcategoryId) await _updateSubCategoryPromptCount(oldPrompt.categoryId, oldPrompt.subcategoryId, -1);
        
        if (updatedPrompt.categoryId) await _updateCategoryPromptCount(updatedPrompt.categoryId, 1);
        if (updatedPrompt.subcategoryId) await _updateSubCategoryPromptCount(updatedPrompt.categoryId, updatedPrompt.subcategoryId, 1);
    }
    return updatedPrompt;
}

async function deletePrompt(id) {
    let prompts = await _getData(PROMPTS_KEY);
    const promptToDelete = prompts.find(p => p.id === id);
    if (!promptToDelete) return false;

    prompts = prompts.filter(p => p.id !== id);
    await _setData(PROMPTS_KEY, prompts);

    if (promptToDelete.categoryId) {
        await _updateCategoryPromptCount(promptToDelete.categoryId, -1);
    }
    if (promptToDelete.subcategoryId) {
        await _updateSubCategoryPromptCount(promptToDelete.categoryId, promptToDelete.subcategoryId, -1);
    }
    // Consider deleting related comments, outputs, favorites, votes here or leave them orphaned
    return true;
}

async function incrementPromptViews(id) {
    let prompts = await _getData(PROMPTS_KEY);
    const promptIndex = prompts.findIndex(p => p.id === id);
    if (promptIndex !== -1) {
        prompts[promptIndex].views = (prompts[promptIndex].views || 0) + 1;
        await _setData(PROMPTS_KEY, prompts);
        return prompts[promptIndex];
    }
    return null;
}

// --- Category Functions ---
async function _updateCategoryPromptCount(categoryId, delta) {
    if (!categoryId) return;
    let categories = await _getData(CATEGORIES_KEY);
    const categoryIndex = categories.findIndex(c => c.id === categoryId);
    if (categoryIndex !== -1) {
        categories[categoryIndex].promptCount = Math.max(0, (categories[categoryIndex].promptCount || 0) + delta);
        await _setData(CATEGORIES_KEY, categories);
    }
}
async function _updateSubCategoryPromptCount(categoryId, subcategoryId, delta) {
    if (!categoryId || !subcategoryId) return;
    let categories = await _getData(CATEGORIES_KEY);
    const categoryIndex = categories.findIndex(c => c.id === categoryId);
    if (categoryIndex !== -1 && categories[categoryIndex].subcategories) {
        const subcategoryIndex = categories[categoryIndex].subcategories.findIndex(sc => sc.id === subcategoryId);
        if (subcategoryIndex !== -1) {
            categories[categoryIndex].subcategories[subcategoryIndex].promptCount = 
                Math.max(0, (categories[categoryIndex].subcategories[subcategoryIndex].promptCount || 0) + delta);
            await _setData(CATEGORIES_KEY, categories);
        }
    }
}

async function getCategories(filters = {}) {
    let categories = await _getData(CATEGORIES_KEY);
    if (filters.status) {
        if (filters.status === 'all_approved') {
            categories = categories.filter(c => c.status === 'approved' || c.status === 'official');
        } else if (filters.status === 'community_approved') {
             categories = categories.filter(c => c.status === 'approved');
        } else {
            categories = categories.filter(c => c.status === filters.status);
        }
    }
    if (filters.userId) {
        categories = categories.filter(c => c.createdBy === filters.userId);
    }
    if (filters.searchTerm) {
        const term = filters.searchTerm.toLowerCase();
        categories = categories.filter(c =>
            c.name.toLowerCase().includes(term) ||
            (c.description && c.description.toLowerCase().includes(term)) ||
            (c.tags && c.tags.some(tag => tag.toLowerCase().includes(term)))
        );
    }
    if (filters.sortBy) {
        categories.sort((a, b) => {
            let valA, valB;
            if (filters.sortBy === 'name' || filters.sortBy === 'name_asc' || filters.sortBy === 'name_desc') {
                valA = a.name.toLowerCase(); valB = b.name.toLowerCase();
            } else if (filters.sortBy === 'prompts' || filters.sortBy === 'prompts_desc' || filters.sortBy === 'prompts_asc') {
                valA = a.promptCount || 0; valB = b.promptCount || 0;
            } else if (filters.sortBy === 'createdDate' || filters.sortBy === 'recent') {
                valA = new Date(a.createdDate); valB = new Date(b.createdDate);
            } else if (filters.sortBy === 'upvotes' || filters.sortBy === 'upvotes_desc') {
                 valA = (a.upvotes || 0) - (a.downvotes || 0);
                 valB = (b.upvotes || 0) - (b.downvotes || 0);
            } else {
                valA = a[filters.sortBy]; valB = b[filters.sortBy];
            }
            const sortOrder = filters.sortOrder || (filters.sortBy.endsWith('_desc') ? 'desc' : 'asc');
            if (sortOrder === 'asc') {
                return valA > valB ? 1 : (valA < valB ? -1 : 0);
            }
            return valB > valA ? 1 : (valB < valA ? -1 : 0);
        });
    }
    return categories;
}

async function getCategoryById(id) {
    const categories = await _getData(CATEGORIES_KEY);
    return categories.find(c => c.id === id) || null;
}

async function addCategory(categoryData) {
    const categories = await _getData(CATEGORIES_KEY);
    const user = await getCurrentUser();
    const newCategory = {
        id: _generateId(),
        createdBy: user.id,
        createdDate: new Date().toISOString(),
        updatedDate: new Date().toISOString(),
        promptCount: 0,
        status: 'pending',
        subcategories: categoryData.subcategories || [],
        tags: categoryData.tags || [],
        icon: categoryData.icon || 'fas fa-folder',
        color: categoryData.color || '#9c27b0', // Default purple
        upvotes: 0,
        downvotes: 0,
        ...categoryData
    };
    categories.push(newCategory);
    await _setData(CATEGORIES_KEY, categories);
    return newCategory;
}

async function updateCategory(id, updatedData) {
    let categories = await _getData(CATEGORIES_KEY);
    const categoryIndex = categories.findIndex(c => c.id === id);
    if (categoryIndex === -1) return null;
    const oldCategory = categories[categoryIndex];
    categories[categoryIndex] = {
        ...oldCategory,
        ...updatedData,
        id: oldCategory.id, // Ensure ID isn't changed
        updatedDate: new Date().toISOString()
    };
    await _setData(CATEGORIES_KEY, categories);
    return categories[categoryIndex];
}

async function deleteCategory(id) {
    let categories = await _getData(CATEGORIES_KEY);
    const categoryToDelete = categories.find(c => c.id === id);
    if (!categoryToDelete) return false;

    categories = categories.filter(c => c.id !== id);
    await _setData(CATEGORIES_KEY, categories);

    let prompts = await _getData(PROMPTS_KEY);
    let promptsReassignedCount = 0;
    prompts.forEach(prompt => {
        if (prompt.categoryId === id) {
            prompt.categoryId = 'uncategorized';
            if (prompt.subcategoryId) prompt.subcategoryId = null;
            promptsReassignedCount++;
        }
    });
    if (promptsReassignedCount > 0) {
        await _setData(PROMPTS_KEY, prompts);
        await _updateCategoryPromptCount('uncategorized', promptsReassignedCount);
    }
    return true;
}

async function addSubcategory(categoryId, subcategoryName) {
    let categories = await _getData(CATEGORIES_KEY);
    const categoryIndex = categories.findIndex(c => c.id === categoryId);
    if (categoryIndex === -1) return null;

    const newSubcategory = {
        id: _generateId(),
        name: subcategoryName,
        promptCount: 0
    };
    categories[categoryIndex].subcategories = categories[categoryIndex].subcategories || [];
    categories[categoryIndex].subcategories.push(newSubcategory);
    categories[categoryIndex].updatedDate = new Date().toISOString();
    await _setData(CATEGORIES_KEY, categories);
    return categories[categoryIndex];
}

async function updateSubcategory(categoryId, subcategoryId, newName) {
    let categories = await _getData(CATEGORIES_KEY);
    const categoryIndex = categories.findIndex(c => c.id === categoryId);
    if (categoryIndex === -1 || !categories[categoryIndex].subcategories) return null;

    const subcategoryIndex = categories[categoryIndex].subcategories.findIndex(sc => sc.id === subcategoryId);
    if (subcategoryIndex === -1) return null;

    categories[categoryIndex].subcategories[subcategoryIndex].name = newName;
    categories[categoryIndex].updatedDate = new Date().toISOString();
    await _setData(CATEGORIES_KEY, categories);
    return categories[categoryIndex];
}

async function deleteSubcategory(categoryId, subcategoryId) {
    let categories = await _getData(CATEGORIES_KEY);
    const categoryIndex = categories.findIndex(c => c.id === categoryId);
    if (categoryIndex === -1 || !categories[categoryIndex].subcategories) return false;

    const oldSubcategories = [...categories[categoryIndex].subcategories];
    categories[categoryIndex].subcategories = categories[categoryIndex].subcategories.filter(sc => sc.id !== subcategoryId);
    
    if (oldSubcategories.length > categories[categoryIndex].subcategories.length) {
        categories[categoryIndex].updatedDate = new Date().toISOString();
        await _setData(CATEGORIES_KEY, categories);
        // Prompts using this subcategory might need their subcategoryId cleared or moved to parent
        let prompts = await _getData(PROMPTS_KEY);
        let changed = false;
        prompts.forEach(p => {
            if (p.categoryId === categoryId && p.subcategoryId === subcategoryId) {
                p.subcategoryId = null; // Clear subcategory
                changed = true;
            }
        });
        if (changed) await _setData(PROMPTS_KEY, prompts);
        return true;
    }
    return false;
}

// --- Comment Functions ---
async function getCommentsForPrompt(promptId) {
    const comments = await _getData(COMMENTS_KEY);
    return comments.filter(c => c.promptId === promptId).sort((a, b) => new Date(b.createdDate) - new Date(a.createdDate)); // Newest first
}

async function addComment(commentData) {
    const comments = await _getData(COMMENTS_KEY);
    const user = await getCurrentUser();
    const newComment = {
        id: _generateId(),
        userId: user.id,
        createdDate: new Date().toISOString(),
        updatedDate: new Date().toISOString(),
        upvotes: 0,
        downvotes: 0,
        ...commentData
    };
    comments.push(newComment);
    await _setData(COMMENTS_KEY, comments);
    return newComment;
}

async function updateComment(commentId, updatedContent) {
    let comments = await _getData(COMMENTS_KEY);
    const commentIndex = comments.findIndex(c => c.id === commentId);
    if (commentIndex === -1) return null;
    comments[commentIndex].content = updatedContent;
    comments[commentIndex].updatedDate = new Date().toISOString();
    await _setData(COMMENTS_KEY, comments);
    return comments[commentIndex];
}

async function deleteComment(commentId) {
    let comments = await _getData(COMMENTS_KEY);
    comments = comments.filter(c => c.id !== commentId);
    await _setData(COMMENTS_KEY, comments);
    return true;
}

// --- Output Functions ---
async function getOutputsForPrompt(promptId) {
    const outputs = await _getData(OUTPUTS_KEY);
    return outputs.filter(o => o.promptId === promptId).sort((a, b) => new Date(b.createdDate) - new Date(a.createdDate)); // Newest first
}

async function addOutput(outputData) {
    const outputs = await _getData(OUTPUTS_KEY);
    const user = await getCurrentUser();
    const newOutput = {
        id: _generateId(),
        userId: user.id,
        createdDate: new Date().toISOString(),
        updatedDate: new Date().toISOString(),
        upvotes: 0,
        downvotes: 0,
        ...outputData
    };
    outputs.push(newOutput);
    await _setData(OUTPUTS_KEY, outputs);
    return newOutput;
}

async function updateOutput(outputId, updatedContent) {
    let outputs = await _getData(OUTPUTS_KEY);
    const outputIndex = outputs.findIndex(o => o.id === outputId);
    if (outputIndex === -1) return null;
    outputs[outputIndex].content = updatedContent;
    outputs[outputIndex].updatedDate = new Date().toISOString();
    await _setData(OUTPUTS_KEY, outputs);
    return outputs[outputIndex];
}

async function deleteOutput(outputId) {
    let outputs = await _getData(OUTPUTS_KEY);
    outputs = outputs.filter(o => o.id !== outputId);
    await _setData(OUTPUTS_KEY, outputs);
    return true;
}

// --- Favorite Functions ---
async function addFavorite(promptId, userId) {
    let favorites = await _getData(FAVORITES_KEY);
    if (!favorites.find(fav => fav.promptId === promptId && fav.userId === userId)) {
        favorites.push({ promptId, userId, date: new Date().toISOString() });
        await _setData(FAVORITES_KEY, favorites);
        let prompts = await _getData(PROMPTS_KEY);
        const promptIndex = prompts.findIndex(p => p.id === promptId);
        if (promptIndex !== -1) {
            prompts[promptIndex].favoritesCount = (prompts[promptIndex].favoritesCount || 0) + 1;
            await _setData(PROMPTS_KEY, prompts);
        }
        return true;
    }
    return false;
}

async function removeFavorite(promptId, userId) {
    let favorites = await _getData(FAVORITES_KEY);
    const initialLength = favorites.length;
    favorites = favorites.filter(fav => !(fav.promptId === promptId && fav.userId === userId));
    if (favorites.length < initialLength) {
        await _setData(FAVORITES_KEY, favorites);
        let prompts = await _getData(PROMPTS_KEY);
        const promptIndex = prompts.findIndex(p => p.id === promptId);
        if (promptIndex !== -1) {
            prompts[promptIndex].favoritesCount = Math.max(0, (prompts[promptIndex].favoritesCount || 0) - 1);
            await _setData(PROMPTS_KEY, prompts);
        }
        return true;
    }
    return false;
}

async function getFavoritesForUser(userId) {
    const favorites = await _getData(FAVORITES_KEY);
    return favorites.filter(fav => fav.userId === userId);
}

async function isFavorite(promptId, userId) {
    const favorites = await _getData(FAVORITES_KEY);
    return favorites.some(fav => fav.promptId === promptId && fav.userId === userId);
}

// --- Vote Functions ---
async function vote(itemId, itemType, userId, voteType) {
    let votes = await _getData(VOTES_KEY);
    const existingVoteIndex = votes.findIndex(v => v.itemId === itemId && v.itemType === itemType && v.userId === userId);
    let scoreChange = { up: 0, down: 0 };

    if (existingVoteIndex !== -1) {
        const oldVote = votes[existingVoteIndex];
        if (oldVote.voteType === voteType) {
            votes.splice(existingVoteIndex, 1);
            if (voteType === 'up') scoreChange.up = -1; else scoreChange.down = -1;
        } else {
            if (oldVote.voteType === 'up') scoreChange.up = -1; else scoreChange.down = -1;
            votes[existingVoteIndex].voteType = voteType;
            votes[existingVoteIndex].date = new Date().toISOString();
            if (voteType === 'up') scoreChange.up = 1; else scoreChange.down = 1;
        }
    } else {
        votes.push({ itemId, itemType, userId, voteType, date: new Date().toISOString() });
        if (voteType === 'up') scoreChange.up = 1; else scoreChange.down = 1;
    }
    await _setData(VOTES_KEY, votes);

    let itemsKey, items;
    if (itemType === 'category') { itemsKey = CATEGORIES_KEY; items = await _getData(CATEGORIES_KEY); }
    else if (itemType === 'comment') { itemsKey = COMMENTS_KEY; items = await _getData(COMMENTS_KEY); }
    else if (itemType === 'output') { itemsKey = OUTPUTS_KEY; items = await _getData(OUTPUTS_KEY); }
    else return false;

    const itemIndex = items.findIndex(item => item.id === itemId);
    if (itemIndex !== -1) {
        items[itemIndex].upvotes = (items[itemIndex].upvotes || 0) + scoreChange.up;
        items[itemIndex].downvotes = (items[itemIndex].downvotes || 0) + scoreChange.down;
        if (items[itemIndex].upvotes < 0) items[itemIndex].upvotes = 0;
        if (items[itemIndex].downvotes < 0) items[itemIndex].downvotes = 0;
        await _setData(itemsKey, items);
    }
    return true;
}

async function getVotesForItem(itemId, itemType) {
    const votes = await _getData(VOTES_KEY);
    const itemVotes = votes.filter(v => v.itemId === itemId && v.itemType === itemType);
    const upvotes = itemVotes.filter(v => v.voteType === 'up').length;
    const downvotes = itemVotes.filter(v => v.voteType === 'down').length;
    return { upvotes, downvotes };
}

async function getUserVoteForItem(itemId, itemType, userId) {
    const votes = await _getData(VOTES_KEY);
    const userVote = votes.find(v => v.itemId === itemId && v.itemType === itemType && v.userId === userId);
    return userVote ? userVote.voteType : null;
}

// --- Export all functions ---
const database = {
    initDatabase,
    getCurrentUser,
    setCurrentUserId, // For testing
    getUserById,
    addUser,
    getPrompts,
    getPromptById,
    addPrompt,
    updatePrompt,
    deletePrompt,
    incrementPromptViews,
    getCategories,
    getCategoryById,
    addCategory,
    updateCategory,
    deleteCategory,
    addSubcategory,
    updateSubcategory,
    deleteSubcategory,
    getCommentsForPrompt,
    addComment,
    updateComment,
    deleteComment,
    getOutputsForPrompt,
    addOutput,
    updateOutput,
    deleteOutput,
    addFavorite,
    removeFavorite,
    getFavoritesForUser,
    isFavorite,
    vote,
    getVotesForItem,
    getUserVoteForItem,
};

export default database;
