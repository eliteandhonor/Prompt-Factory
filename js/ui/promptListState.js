// promptListState.js - State management and search/filter logic for Prompt List

let currentParams = {};

export function getCurrentParams() {
  return { ...currentParams };
}

export function setCurrentParams(params) {
  currentParams = { ...params };
}

export function setSearchQuery(query, { updateInput = true } = {}) {
  const searchInput = document.querySelector('[data-testid="prompt-search-input"]');
  currentParams.search = query;
  if (updateInput && searchInput && searchInput.value !== query) {
    searchInput.value = query;
  }
  if (typeof window.debugLog === "function") {
    window.debugLog("[SYNC] setSearchQuery called", { query, currentParams, inputValue: searchInput ? searchInput.value : undefined });
  }
  if (typeof window.renderPrompts === "function") {
    window.renderPrompts();
  }
}

// Centralized filter update logic for filterPrompts event
export function updateFiltersFromEvent(detail) {
  const filterKeys = ['myPrompts', 'category', 'tag', 'userId'];
  if (!detail || Object.keys(detail).length === 0 || !filterKeys.some(k => k in detail)) {
    // Clear all filter keys
    delete currentParams.userId;
    delete currentParams.category;
    delete currentParams.tag;
    // Reset UI controls
    const filterCategory = document.getElementById('filter-category');
    if (filterCategory) filterCategory.value = '';
    const filterTag = document.getElementById('filter-tag');
    if (filterTag) filterTag.value = '';
    setSearchQuery('', { updateInput: true });
  } else {
    // If only one filter key is present, clear all others before setting
    const keysInDetail = Object.keys(detail).filter(k => filterKeys.includes(k));
    if (keysInDetail.length === 1) {
      filterKeys.forEach(k => {
        if (k !== keysInDetail[0]) delete currentParams[k];
      });
    }
    if ('myPrompts' in detail) {
      if (detail.myPrompts) {
        currentParams.userId = 'me';
      } else {
        delete currentParams.userId;
      }
    }
    if ('category' in detail) {
      if (detail.category) {
        currentParams.category = detail.category;
      } else {
        delete currentParams.category;
      }
    }
    if ('tag' in detail) {
      if (detail.tag) {
        currentParams.tag = detail.tag;
      } else {
        delete currentParams.tag;
      }
    }
  }
}