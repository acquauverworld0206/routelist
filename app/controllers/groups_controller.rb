class GroupsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_group, only: [:show, :edit, :update, :random_draw, :destroy]

  def index
    # 自分が所属しているグループ（ホストとして作成したもの、またはメンバーとして参加しているもの）を一覧表示
    @groups = current_user.groups.order(created_at: :desc)
  end

  def new
    @group = Group.new
  end

  def create
    # 自分がホストとなるグループを作成
    # group_paramsにデフォルトのステータスをマージする
    @group = current_user.hosted_groups.build(group_params.merge(status: 'planning'))
    if @group.save
      # グループ作成と同時に、自分自身をメンバーとして追加する
      @group.group_members.create(user: current_user, role: 'admin')
      redirect_to groups_path, notice: "新しいグループを作成しました。"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def show
    # フォームで使うスポットのリスト
    @my_spots = current_user.spots
    # 新しい候補地追加フォーム用のオブジェクト
    @candidate_spot = @group.candidate_spots.new
  end

  def edit
    # @groupはbefore_actionでセットされます
    # グループのホストでなければ編集ページにアクセスできないようにする
    unless @group.host == current_user
      redirect_to group_path(@group), alert: "グループを編集する権限がありません。"
    end
  end

  def update
    # グループのホストでなければ更新できないようにする
    unless @group.host == current_user
      redirect_to group_path(@group), alert: "グループを編集する権限がありません。"
      return
    end

    if @group.update(group_params)
      redirect_to group_path(@group), notice: "グループ情報を更新しました。"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    # グループのホストでなければ削除できないようにする
    unless @group.host == current_user
      redirect_to group_path(@group), alert: "グループを削除する権限がありません。"
      return
    end

    @group.destroy
    redirect_to groups_path, notice: "グループ「#{@group.name}」を削除しました。", status: :see_other
  end

  def random_draw
    # 常に1つのスポットを抽選する
    count = 1

    # 候補地リストを取得
    candidate_spots = @group.candidate_spots

    # 候補地が1つもない場合は、グループ詳細ページに戻ってメッセージを表示
    if candidate_spots.empty?
      redirect_to group_path(@group), alert: "抽選する候補地がありません。"
      return
    end

    # 候補地リストから指定された個数をランダムに抽選
    @selected_spots = candidate_spots.sample(count)
  end

  private

  def set_group
    # 自分が所属しているグループの中から探すことで、他人のグループを閲覧できないようにする
    @group = current_user.groups.find(params[:id])
  end

  def group_params
    params.require(:group).permit(:name, :description, :status)
  end
end