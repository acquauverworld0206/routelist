class CandidateSpotsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_group

  def create
    # フォームから送信されたspot_idを取得
    spot_id = params[:candidate_spot][:spot_id]
    # ユーザーが所有するスポットの中から探す
    spot = current_user.spots.find_by(id: spot_id)

    if spot.nil?
      redirect_to group_path(@group), alert: "スポットが見つかりません。"
      return
    end

    # 新しい候補地を作成
    @candidate_spot = @group.candidate_spots.new(spot: spot, added_by: current_user)

    if @candidate_spot.save
      redirect_to group_path(@group), notice: "「#{spot.name}」を候補地に追加しました。"
    else
      redirect_to group_path(@group), alert: "候補地の追加に失敗しました。#{@candidate_spot.errors.full_messages.join(', ')}"
    end
  end

  private

  def set_group
    @group = current_user.groups.find(params[:group_id])
  end
end
