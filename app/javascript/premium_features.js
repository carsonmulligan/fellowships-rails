document.addEventListener('DOMContentLoaded', function() {
  // Get DOM elements
  const modal = document.getElementById('premium-features-modal');
  const closeBtn = document.querySelector('.close-btn');
  const emailInput = document.getElementById('premium-email');
  const joinButton = document.querySelector('.join-fellows-btn');
  const videoContainer = document.querySelector('.video-container');

  // Handle modal open
  if (joinButton) {
    joinButton.addEventListener('click', function() {
      modal.style.display = 'block';
    });
  }

  // Handle modal close
  if (closeBtn) {
    closeBtn.addEventListener('click', function() {
      modal.style.display = 'none';
    });
  }

  // Close modal when clicking outside
  window.addEventListener('click', function(event) {
    if (event.target == modal) {
      modal.style.display = 'none';
    }
  });

  // Handle video play
  if (videoContainer) {
    videoContainer.addEventListener('click', function() {
      const iframe = document.createElement('iframe');
      iframe.setAttribute('src', 'https://www.youtube.com/embed/UVtrvArSihQ?autoplay=1');
      iframe.setAttribute('frameborder', '0');
      iframe.setAttribute('allow', 'accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture');
      iframe.setAttribute('allowfullscreen', '');
      iframe.style.width = '100%';
      iframe.style.height = '100%';

      // Replace play button with iframe
      videoContainer.innerHTML = '';
      videoContainer.appendChild(iframe);
    });
  }

  // Handle email collection
  const collectEmailForm = document.getElementById('collect-email-form');
  if (collectEmailForm) {
    collectEmailForm.addEventListener('submit', function(e) {
      e.preventDefault();
      const email = document.getElementById('user-email').value;
      
      // Store email in localStorage
      localStorage.setItem('user_email', email);
      
      // Update premium modal email input
      if (emailInput) {
        emailInput.value = email;
      }
      
      // Show premium features modal
      if (modal) {
        modal.style.display = 'block';
      }
    });
  }
}); 