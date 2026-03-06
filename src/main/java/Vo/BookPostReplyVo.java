package Vo;

import java.sql.Timestamp;

public class BookPostReplyVo {
	private int replyId;
	private int postId;
	private String userId;
	private String replyContent;
	private Timestamp replytimeAt;

	public BookPostReplyVo() {
		super();
	}

	public BookPostReplyVo(int postId, String userId, String replyContent) {
		super();
		this.postId = postId;
		this.userId = userId;
		this.replyContent = replyContent;
	}

	public BookPostReplyVo(int replyId, int postId, String userId, String replyContent, Timestamp replytimeAt) {
		super();
		this.replyId = replyId;
		this.postId = postId;
		this.userId = userId;
		this.replyContent = replyContent;
		this.replytimeAt = replytimeAt;
	}

	public BookPostReplyVo(int replyId, String userId, String replyContent, Timestamp replytimeAt) {
		super();
		this.replyId = replyId;
		this.userId = userId;
		this.replyContent = replyContent;
		this.replytimeAt = replytimeAt;
	}

	public int getReplyId() {
		return replyId;
	}

	public void setReplyId(int replyId) {
		this.replyId = replyId;
	}

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

	public String getReplyContent() {
		return replyContent;
	}

	public void setReplyContent(String replyContent) {
		this.replyContent = replyContent;
	}

	public Timestamp getReplytimeAt() {
		return replytimeAt;
	}

	public void setReplytimeAt(Timestamp replytimeAt) {
		this.replytimeAt = replytimeAt;
	}
}
