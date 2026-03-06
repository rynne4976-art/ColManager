package Vo;

import java.sql.Timestamp;
import java.util.List;

public class BookPostVo {
	// 글 번호 (자동 증가)
	private int postId;
	// 유저 아이디
	private String userId;
	// 글 제목
	private String postTitle;
	// 글 내용
	private String postContent;
	// 학과 태그
	private String majorTag;
	// 생성일시
	private Timestamp createdAt;
	// 이미지 리스트
	private List<BookImage> images;

	// 기본 생성자
	public BookPostVo() {
	}

	public BookPostVo(String majorTag) {
		super();
		this.majorTag = majorTag;
	}

	// 모든 필드를 포함한 생성자
	public BookPostVo(int postId, String userId, String postTitle, String postContent, String majorTag,
			Timestamp createdAt, List<BookImage> images) {
		this.postId = postId;
		this.userId = userId;
		this.postTitle = postTitle;
		this.postContent = postContent;
		this.majorTag = majorTag;
		this.createdAt = createdAt;
		this.images = images;
	}

	public BookPostVo(String userId, String postTitle, String postContent, String majorTag) {
		super();
		this.userId = userId;
		this.postTitle = postTitle;
		this.postContent = postContent;
		this.majorTag = majorTag;
	}

	public BookPostVo(int postId, String userId, String postTitle, String majorTag, Timestamp createdAt) {
		super();
		this.postId = postId;
		this.userId = userId;
		this.postTitle = postTitle;
		this.majorTag = majorTag;
		this.createdAt = createdAt;
	}

	public BookPostVo(int postId, String userId, String postTitle, String postContent, String majorTag,
			Timestamp createdAt) {
		super();
		this.postId = postId;
		this.userId = userId;
		this.postTitle = postTitle;
		this.postContent = postContent;
		this.majorTag = majorTag;
		this.createdAt = createdAt;
	}

	public BookPostVo(String userId, String postTitle, String postContent, String majorTag, Timestamp createdAt,
			List<BookImage> images) {
		super();
		this.userId = userId;
		this.postTitle = postTitle;
		this.postContent = postContent;
		this.majorTag = majorTag;
		this.createdAt = createdAt;
		this.images = images;
	}

	// Getter와 Setter 메서드
	public int getPostId() {
		return postId;
	}

	public void setPostId(int postId) {
		this.postId = postId;
	}

	public String getUserId() {
		return userId;
	}

	public void setUserId(String userId) {
		this.userId = userId;
	}

	public String getPostTitle() {
		return postTitle;
	}

	public void setPostTitle(String postTitle) {
		this.postTitle = postTitle;
	}

	public String getPostContent() {
		return postContent;
	}

	public void setPostContent(String postContent) {
		this.postContent = postContent;
	}

	public String getMajorTag() {
		return majorTag;
	}

	public void setMajorTag(String majorTag) {
		this.majorTag = majorTag;
	}

	public Timestamp getCreatedAt() {
		return createdAt;
	}

	public void setCreatedAt(Timestamp createdAt) {
		this.createdAt = createdAt;
	}

	public List<BookImage> getImages() {
		return images;
	}

	public void setImages(List<BookImage> images) {
		this.images = images;
	}

	// 내부 클래스 - BookImage
	public static class BookImage {
		// 이미지 번호 (자동 증가)
		private int imageId;
		// 글 번호
		private int postId;
		// 이미지 파일 이름
		private String fileName;
		// 이미지 파일 경로
		private String image_path;
		// 저장 파일 이름
		private String uniqueFileName;

		// 기본 생성자
		public BookImage() {
		}

		public String getUniqueFileName() {
			return uniqueFileName;
		}

		public void setUniqueFileName(String uniqueFileName) {
			this.uniqueFileName = uniqueFileName;
		}

		// 모든 필드를 포함한 생성자
		public BookImage(int imageId, int postId, String fileName, String image_path) {
			this.imageId = imageId;
			this.postId = postId;
			this.fileName = fileName;
			this.image_path = image_path;
		}

		public BookImage(String fileName, String imagePath) {
			super();
			this.fileName = fileName;
			this.image_path = imagePath;
		}

		// Getter와 Setter 메서드
		public int getImageId() {
			return imageId;
		}

		public void setImageId(int imageId) {
			this.imageId = imageId;
		}

		public int getPostId() {
			return postId;
		}

		public void setPostId(int postId) {
			this.postId = postId;
		}

		public String getFileName() {
			return fileName;
		}

		public void setFileName(String fileName) {
			this.fileName = fileName;
		}

		public String getImage_path() {
			return image_path;
		}

		public void setImage_path(String image_path) {
			this.image_path = image_path;
		}

	}

}
